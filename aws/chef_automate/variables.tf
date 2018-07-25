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

variable "aws_image_user" {
  default = "ubuntu"
}

////////////////////////////////
// Tags

variable "tag_customer" {
  default = "chef"
}

variable "tag_project" {
  default = "chef"
}

variable "tag_name" {
  default = "chef"
}

variable "tag_dept" {
  default = "engineering"
}

variable "tag_contact" {
  default = "admin@example.com"
}

variable "tag_application" {
  default = "Chef Automate 2"
}

variable "tag_ttl" {
  default = 3600
}

////////////////////////////////
// AWS Configuration

variable "aws_key_pair_file" {
  default = "~/.ssh/ec2-keypair.key"
}

variable "aws_key_pair_name" {
  default = "ec2-keypair"
}

variable "automate_server_instance_type" {
  default = "m4.xlarge"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

// Point at an  pre-existing EIP. If this is
// false we'll just use the allocated public IP of the
// EC instance
variable "eipalloc_id" {
  default = false
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

variable "automate_host_name" {
  default = "automate"
}

variable "automate_domain_name" {
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