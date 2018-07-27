output "server_fqdn" {
  value = "https://${var.host_name}.${var.domain_name}"
}

output "server_public_ip" {
  value = "${data.aws_eip.chef_automate.public_ip}"
}

output "server_password" {
  value =  "${module.server_password.stdout}"
}

output "server_username" {
  value =  "${module.server_username.stdout}"
}

output "server_api_token" {
  value =  "${module.server_api_token.stdout}"
}


