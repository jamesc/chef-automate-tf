
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
  description = "ID of the EIP for the Chef Server (must be already allocated)"
}

/////////////////////////////////
// Chef Server Configuration
variable "admin_email" {}
variable "admin_username" {}
variable "admin_user" {}
variable "admin_password" {}

variable "organization_id" {
  default = "chef"
}

variable "organization_name" {
  default = "Chef"
}

variable "host_name" {
  default = "chef"
}

variable "domain_name" {
  default = "example.com"
}

///////////////////////
// Automate data collector
variable "automate_host_name" {}

variable "automate_domain_name" {}

variable "automate_api_token" {}
