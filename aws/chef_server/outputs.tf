output "server_fqdn" {
  value = "https://${var.host_name}.${var.domain_name}"
}

output "server_public_ip" {
  value = "${data.aws_eip.chef_server.public_ip}"
}

output "server_admin_public_key" {
    value = "${tls_private_key.chef_server_admin.public_key_pem}"
}

output "server_admin_private_key" {
    value = "${tls_private_key.chef_server_admin.private_key_pem}"
}

// For dependencies
output "server_ready" {
  value = "${null_resource.chef_server_ready.id}"
}