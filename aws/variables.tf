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


variable "automate_eipalloc_id" {
}

variable "chef_server_eipalloc_id" {
}

/////////////////////////////////
// Secrets
variable "admin_email" {
  default = "admin@example.com"
}

variable "admin_username" {
  default = "admin"
}

variable "admin_user" {
  default = "The Boss"
}
variable "admin_password" {
  default = "ThisIsVerySecretPassword"
}

/////////////////////////////////
// Automate 2 Configuration

variable "automate_host_name" {
  default = "automate"
}

variable "automate_domain_name" {
  default = "example.com"
}

////////////////////////////////
// Automate Keys and Licenses
variable "automate_license" {
  default = ""
  description = "Contact Chef Sales at sales@chef.io to request a license."
}


////////////////////////////////
// Chef Server configuration

variable "chef_server_host_name" {
  default = "chef"
}

variable "chef_server_domain_name" {
  default = "example.com"
}

variable "chef_server_version" {
  default = "12.17.33"
}