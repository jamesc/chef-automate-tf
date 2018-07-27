output "chef_automate_server_fqdn" {
  value = "${module.chef_automate.server_fqdn}"
}

output "chef_automate_server_public_ip" {
  value = "${module.chef_automate.server_public_ip}"
}

output "chef_automate_username" {
  value = "${module.chef_automate.server_username}"
}

output "chef_automate_password" {
  value = "${module.chef_automate.server_password}"
}

output "aws_vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "aws_subnet_id" {
  value = "${module.vpc.subnet_id}"
}

