data "template_file" "install_chef_automate_cli" {
  template = "${file("${path.module}/templates/install_chef_automate_cli.sh.tpl")}"

  vars {
    channel = "${var.channel}"
  }
}

data "template_file" "chef_automate_config" {
  template = "${file("${path.module}/templates/config.toml.tpl")}"

  vars {
    domain_name = "${var.automate_domain_name}"
    host_name = "${var.automate_host_name}"
    admin_email = "${var.admin_email}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    automate_license = "${var.automate_license}"
    frontend_cert = "${var.frontend_cert}"
    frontend_key = "${var.frontend_key}"
  }
}

// only associate with EIP if an ID is given
resource "aws_eip_association" "eip_assoc_2" {
  count = "${replace(var.eipalloc_id, "/^eip.*$/", "1")}"
  instance_id   = "${aws_instance.chef_automate.id}"
  allocation_id = "${var.eipalloc_id}"
}

resource "aws_instance" "chef_automate" {
  connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.automate_server_instance_type}"
  key_name               = "${var.aws_key_pair_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef_automate.id}"]
  ebs_optimized          = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${format("chef_automate_${random_id.instance_id.hex}")}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "file" {
    destination = "/tmp/install_chef_automate_cli.sh"
    content     = "${data.template_file.install_chef_automate_cli.rendered}"
  }

  provisioner "file" {
    destination = "/tmp/config.toml"
    content     = "${data.template_file.chef_automate_config.rendered}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${var.automate_host_name}.${var.automate_domain_name}",
      "sudo chmod +x /tmp/install_chef_automate_cli.sh",
      "sudo bash /tmp/install_chef_automate_cli.sh",
      "sudo mv /tmp/config.toml /etc/chef-automate/config.toml",
      "sudo chef-automate deploy /etc/chef-automate/config.toml --accept-terms-and-mlsa",
      "sudo chown centos:centos /home/centos/automate-credentials.toml",
      "sudo echo -e \"api-token =\"$(sudo chef-automate admin-token) >> automate-credentials.toml",
      "sudo cat /home/centos/automate-credentials.toml",
    ]
  }
}
