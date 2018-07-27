data "template_file" "install_chef_automate_cli" {
  template = "${file("${path.module}/templates/install_chef_automate_cli.sh.tpl")}"

  vars {
    channel = "${var.channel}"
  }
}

data "template_file" "chef_automate_config" {
  template = "${file("${path.module}/templates/config.toml.tpl")}"

  vars {
    domain_name = "${var.domain_name}"
    host_name = "${var.host_name}"
    admin_email = "${var.admin_email}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    automate_license = "${var.automate_license}"
    frontend_cert = "${var.frontend_cert}"
    frontend_key = "${var.frontend_key}"
  }
}

// only associate with EIP if an ID is given
resource "aws_eip_association" "chef_automate" {
  instance_id   = "${aws_instance.chef_automate.id}"
  allocation_id = "${var.eipalloc_id}"
}

data "aws_eip" "chef_automate" {
  id = "${var.eipalloc_id}"
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
      "sudo hostnamectl set-hostname ${var.host_name}.${var.domain_name}",
      "sudo chmod +x /tmp/install_chef_automate_cli.sh",
      "sudo bash /tmp/install_chef_automate_cli.sh",
      "sudo mv /tmp/config.toml /etc/chef-automate/config.toml",
      "sudo chef-automate deploy /etc/chef-automate/config.toml --accept-terms-and-mlsa",
      "sudo chown centos:centos /home/centos/automate-credentials.toml",
      "sudo echo -e \"api-token = \"$(sudo chef-automate admin-token) >> automate-credentials.toml",
      "sudo cat /home/centos/automate-credentials.toml",
    ]
  }
}

// Workaround to get back the various parameters created by Chef Automate
resource "null_resource" "get_credentials" {
  provisioner "local-exec" {
    command = <<CMD
    scp -i ${var.aws_key_pair_file} -o StrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null \
      ${var.aws_centos_image_user}@${data.aws_eip.chef_automate.public_ip}:automate-credentials.toml \
      output-automate-credentials.toml
    CMD
  }
  depends_on = ["aws_eip_association.chef_automate"]
}

module "server_password" {
  source = "matti/resource/shell"
  command = "cat output-automate-credentials.toml|grep password|cut -c12-|sed -e 's/^\"//' -e 's/\"$//'"
  depends_id = "${null_resource.get_credentials.id}"
}

module "server_username" {
  source = "matti/outputs/shell"
  command = "cat output-automate-credentials.toml|grep username|cut -c12-|sed -e 's/^\"//' -e 's/\"$//'"
  depends_id = "${null_resource.get_credentials.id}"
}

module "server_api_token" {
  source = "matti/outputs/shell"
  command = "cat output-automate-credentials.toml|grep api-token|cut -c13-"
  depends_id = "${null_resource.get_credentials.id}"
}