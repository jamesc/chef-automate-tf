output "server_fqdn" {
  value = "https://${var.host_name}.${var.domain_name}"
}

output "server_public_ip" {
  value = "${data.aws_eip.chef_server.public_ip}"
}

// For dependencies
output "server_ready" {
  value = "${null_resource.chef_server_ready.id}"
}