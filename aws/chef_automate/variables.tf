////////////////////////////////
// AWS Connection

variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "us-west-2"
}

////////////////////////////////
// Server Settings
variable "aws_centos_image_user" {
  default = "centos"
}

////////////////////////////////
// Tags

variable "tag_customer" {}
variable "tag_project" {}
variable "tag_name" {}
variable "tag_dept" {}
variable "tag_contact" {}
variable "tag_application" {}
variable "tag_ttl" {}

////////////////////////////////
// AWS Configuration

variable "aws_key_pair_file" {}
variable "aws_key_pair_name" {}

variable "server_instance_type" {
  default = "m4.xlarge"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}


variable "eipalloc_id" {
  description = "ID of the EIP for the Chef Automate server (must be already allocated)"
}

/////////////////////////////////
// Automate 2 Configuration
variable "admin_email" {
  default = "admin@example.com"
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = "ThisIsVerySecretPassword"
}

variable "host_name" {
  default = "automate"
}

variable "domain_name" {
  default = "example.com"
}


////////////////////////////////
// Habitat

variable "channel" {
  default = "current"
}

////////////////////////////////
// Automate License

variable "automate_license" {
  description = "Contact Chef Sales at sales@chef.io to request a license."
}

variable "frontend_cert" {
  description = <<EOF
Certificate for the Frontend Loadbalancer.

You can generate a self-signed certificate as follows:

  openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem

The certificate self-signed certificate will likely produce
security warnings when you visit Chef Automate in your web
browser. We recommend using a certificate signed by a certificate authority you trust.
EOF
}

variable "frontend_key" {
  description = <<EOF
Corresponding key for the Frontend Loadbalancer.
EOF
}