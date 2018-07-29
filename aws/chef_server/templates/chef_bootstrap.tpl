#!/bin/bash

set -e

cd /tmp && wget https://packages.chef.io/files/stable/chef-server/${version}/el/7/chef-server-core-${version}-1.el7.x86_64.rpm
rpm -Uvh -i /tmp/chef-server-core-${version}-1.el7.x86_64.rpm

mkdir -p /etc/opscode/
mv /tmp/chef-server.rb /etc/opscode
chmod 600 /etc/opscode


chef-server-ctl reconfigure

chef-server-ctl user-create ${admin_username} ${admin_user} ${admin_email} ${admin_password} --filename /tmp/${admin_username}.pem
chef-server-ctl org-create ${organization_id} "${organization_name}" --association_user ${admin_username} --filename /tmp/${organization_id}-validator.pem

# Data collector
chef-server-ctl set-secret data_collector token ${automate_api_token}
sudo chef-server-ctl restart nginx
sudo chef-server-ctl restart opscode-erchef

# JC-  Don't install manage
#chef-server-ctl install chef-manage
#chef-server-ctl reconfigure
#chef-manage-ctl reconfigure --accept-license

echo "Finished"