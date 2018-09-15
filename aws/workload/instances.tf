resource "aws_instance" "production" {
  depends_on = ["null_resource.wait_for_chef_server"]

  connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.base_linux.id}", "${aws_security_group.habitat_supervisor.id}"]
  associate_public_ip_address = true

  tags {
    Name          = "app_centos_production_${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostname ${var.workload_hostname}",

    ]
  }

  provisioner "chef" {
    environment     = "_default"
    run_list        = []
    node_name       = "${var.workload_hostname}"
    server_url      = "https://${var.chef_server}/organizations/${var.chef_organization_id}/"
    recreate_client = true
    user_name       = "${var.admin_username}"
    user_key        = "${var.admin_private_key}"
    #version         = "14.4.17"

    ssl_verify_mode = ":verify_peer"
    fetch_chef_certificates = true
  }
}
