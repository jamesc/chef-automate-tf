provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}

module ssl_certs {
  source = "./ssl_certs"

  automate_domain_name = "${var.automate_domain_name}"
  automate_host_name = "${var.automate_host_name}"
}

module vpc {
    source = "./vpc"

    tag_customer = "${var.tag_customer}"
    tag_project = "${var.tag_project}"
    tag_name = "${var.tag_name}"
    tag_dept = "${var.tag_dept}"
    tag_contact = "${var.tag_contact}"
    tag_application = "${var.tag_ttl}"
    tag_ttl = "${var.tag_ttl}"
}

module chef_automate {
  source = "./chef_automate"

    tag_customer = "${var.tag_customer}"
    tag_project = "${var.tag_project}"
    tag_name = "${var.tag_name}"
    tag_dept = "${var.tag_dept}"
    tag_contact = "${var.tag_contact}"
    tag_application = "${var.tag_application}"
    tag_ttl = "${var.tag_ttl}"

    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.automate_subnet_id}"

    aws_key_pair_file = "${var.aws_key_pair_file}"
    aws_key_pair_name = "${var.aws_key_pair_name}"

    host_name = "${var.automate_host_name}"
    domain_name = "${var.automate_domain_name}"
    eipalloc_id = "${var.automate_eipalloc_id}"

    admin_email = "${var.admin_email}"
    admin_username = "${var.admin_username}"
    // TODO - This password doesn't seem to be used ???
    admin_password = "${var.admin_password}"

    automate_license = "${var.automate_license}"

    // Use our self-signed Certs
    // TODO - Change this to load certs from disk if you have real
    //        signed certs
    frontend_key = "${module.ssl_certs.chef_automate_private_key_pem}"
    frontend_cert = "${module.ssl_certs.chef_automate_cert_pem}"
}

module chef_server {
  source = "./chef_server"

  tag_customer = "${var.tag_customer}"
  tag_project = "${var.tag_project}"
  tag_name = "${var.tag_name}"
  tag_dept = "${var.tag_dept}"
  tag_contact = "${var.tag_contact}"
  tag_application = "${var.tag_application}"
  tag_ttl = "${var.tag_ttl}"

  vpc_id = "${module.vpc.vpc_id}"
  subnet_id = "${module.vpc.automate_subnet_id}"

  aws_key_pair_file = "${var.aws_key_pair_file}"
  aws_key_pair_name = "${var.aws_key_pair_name}"

  host_name = "${var.chef_server_host_name}"
  domain_name = "${var.chef_server_domain_name}"
  eipalloc_id = "${var.chef_server_eipalloc_id}"

  automate_host_name = "${var.automate_host_name}"
  automate_domain_name = "${var.automate_domain_name}"
  automate_api_token = "${module.chef_automate.server_api_token}"

  version = "${chef_server_version}"
  admin_username = "${var.admin_username}"
  admin_password = "${var.admin_password}"
  admin_email = "${var.admin_email}"
  admin_user = "${var.admin_user}"
}

resource "null_resource" "chef_server_ready" {
  triggers {
    chef_server_ready = "${module.chef_server.server_ready}"
  }
}

module "workload" {
  source = "./workload"

  tag_customer = "${var.tag_customer}"
  tag_project = "${var.tag_project}"
  tag_name = "${var.tag_name}"
  tag_dept = "${var.tag_dept}"
  tag_contact = "${var.tag_contact}"
  tag_application = "${var.tag_application}"
  tag_ttl = "${var.tag_ttl}"

  vpc_id = "${module.vpc.vpc_id}"
  subnet_id = "${module.vpc.workload_subnet_id}"

  aws_key_pair_file = "${var.aws_key_pair_file}"
  aws_key_pair_name = "${var.aws_key_pair_name}"

  chef_server = "${var.chef_server_host_name}.${var.chef_server_domain_name}"
  admin_username = "${var.admin_username}"
  admin_private_key = "${module.chef_server.server_admin_private_key}"

  chef_server_ready = "${null_resource.chef_server_ready.id}"
}
