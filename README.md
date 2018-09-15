# Chef Automate Terraform
Terraform configuration for spinning up Chef Automate and a Chef Server in AWS

## Overview
This repo contains terraform templates to create a VPC which contains a Chef Automate instance
and a Chef Server connected to it.


## Pre-Setup
Both the Chef Server and Chef Automate require  FQDNs to be assigned.  To make this easier
this example configuration uses 2 Elastic IPs for the Chef Automate server and the
Chef Server instance.  These can bound to DNS records outside of the template (in the case you're not using Route 53 for DNS).

If you have one, you can supply a Chef Automate license key.  If one is not supplied you can reqister for a 60 day evaluation license within the Chef Automate UI.

## Configuration
There is a minimal example configuration in `aws/terraform.tfvars.example`.

## Install Chef Automate
* Run `terraform init <CLOUD>` to setup terraform modules


* Run `terraform apply <CLOUD>` to create all the infrastructure.

```
$ terraform apply -auto-approve aws
data.template_file.install_chef_automate_cli: Refreshing state...
data.template_file.chef_server_rb: Refreshing state...
data.aws_ami.centos: Refreshing state...
data.aws_eip.chef_automate: Refreshing state...
data.aws_eip.chef_server: Refreshing state...``
data.aws_ami.centos: Refreshing state...
module.chef_server.random_id.instance_id: Creating...
...
...
...
module.chef_server.aws_eip_association.chef_server: Creating...
  allocation_id:        "" => "eipalloc-020892024920cf878"
  instance_id:          "" => "i-02333b922bf0c895c"
  network_interface_id: "" => "<computed>"
  private_ip_address:   "" => "<computed>"
  public_ip:            "" => "<computed>"
module.chef_server.aws_eip_association.chef_server: Creation complete after 1s (ID: eipassoc-016c5caa24cec52cf)

Apply complete! Resources: 36 added, 0 changed, 0 destroyed.
```

## Outputs

The output configuration can be obtained via `terraform outputs`.  Also credentials and keys are dropped into the `output` qirectory. An example output is :

``` terraform output
$ terraform output
aws_subnet_id = subnet-0c06f93159f789d6f
aws_vpc_id = vpc-0489d2154bd6c5c19
chef_automate_password = 05b6fcde82bd2a5192d795d931477398
chef_automate_server_fqdn = https://automate.jamesc.net
chef_automate_server_public_ip = 54.71.211.164
chef_automate_username = james@chef.io
chef_server_password = f4363cbf-a75e-49e5-8bc2-7b34583446dd
chef_server_username = admin
```

The `aws/output` directory will contain the following:

* `automate-credentials.toml`: A copy of the Chef Automate user credentials created during the installation process
* `<admin_username>.pem`: The Chef client pem file for the admin user
* `<org>-validator.pem`: The Validator key for the Chef Server org that was created
## License
This code is under the Apache 2 license. See `LICENSE` for details.
