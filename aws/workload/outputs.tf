output "app_server_public_ip" {
  value = "${aws_instance.production.public_ip}"
}