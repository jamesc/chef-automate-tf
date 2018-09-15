variable "chef_server" {
    default = "chef.example.com"
}

variable "chef_organization_id" {
    default = "chef"
}

variable "admin_username" {
    default = "admin"
}

variable "admin_private_key" {}

variable "workload_run_list_item" {
    default = "recipe[hab_national_parks]"
}

variable "workload_hostname" {
  default = "app1"
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


variable "instance_type" {
  default = "t2.medium"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

// For module dependencies
variable "chef_server_ready" {
}