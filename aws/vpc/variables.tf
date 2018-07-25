////////////////////////////////
// AWS Connection

variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "us-west-2"
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
