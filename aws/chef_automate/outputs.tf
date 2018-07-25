output "chef_automate_server_fqdn" {
  value = "https://${var.automate_host_name}.${var.automate_domain_name}"
}

output "chef_automate_server_public_ip" {
  value = "${aws_instance.chef_automate.public_ip}"
}
