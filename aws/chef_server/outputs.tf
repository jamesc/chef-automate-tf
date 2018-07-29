output "server_fqdn" {
  value = "https://${var.host_name}.${var.domain_name}"
}

output "server_public_ip" {
  value = "${data.aws_eip.chef_server.public_ip}"
}
