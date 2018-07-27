data "template_file" "chef_bootstrap" {
  template = "${file("${path.module}/templates/chef_bootstrap.tpl")}"

  vars {
    admin_username = "${var.admin_username}"
    admin_user = "${var.admin_user}"
    admin_password = "${var.admin_password}"
    admin_email = "${var.admin_email}"
    organization_id = "${var.organization_id}"
    organization_name = "${var.organization_name}"
    automate_api_token = "${var.automate_api_token}"
  }
}

data "template_file" "chef_server_rb" {
  template = "${file("${path.module}/templates/chef-server.rb.tpl")}"

  vars {
    automate_host_name = "${var.automate_host_name}"
    automate_domain_name = "${var.automate_domain_name}"
  }
}
// only associate with EIP if an ID is given
resource "aws_eip_association" "chef_server" {
  instance_id   = "${aws_instance.chef_server.id}"
  allocation_id = "${var.eipalloc_id}"
}

data "aws_eip" "chef_server" {
  id = "${var.eipalloc_id}"
}

resource "aws_instance" "chef_server" {
  connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.server_instance_type}"
  key_name               = "${var.aws_key_pair_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef_server.id}"]
  ebs_optimized          = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${format("chef_server_${random_id.instance_id.hex}")}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "file" {
    destination = "/tmp/chef_bootstrap.sh"
    content     = "${data.template_file.chef_bootstrap.rendered}"
  }

 provisioner "file" {
    destination = "/tmp/chef-server.rb"
    content     = "${data.template_file.chef_server_rb.rendered}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${var.host_name}.${var.domain_name}",
      "sudo chmod +x /tmp/chef_bootstrap.sh",
      "sudo bash /tmp/chef_bootstrap.sh",
    ]
  }
}

