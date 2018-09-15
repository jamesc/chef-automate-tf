#!/bin/bash

set -e

cd /tmp && wget https://packages.chef.io/files/stable/chef-server/${version}/el/7/chef-server-core-${version}-1.el7.x86_64.rpm
rpm -Uvh -i /tmp/chef-server-core-${version}-1.el7.x86_64.rpm

mkdir -p /etc/opscode/
mv /tmp/chef-server.rb /etc/opscode
chmod 600 /etc/opscode

echo "Running chef-server-ctl reconfigure..."
chef-server-ctl reconfigure >/dev/null 2>&1
echo "Done"

# Use our private key
chef-server-ctl user-create ${admin_username} ${admin_user} ${admin_email} ${admin_password} --filename /dev/null
chef-server-ctl delete-user-key ${admin_username} default
chef-server-ctl add-user-key ${admin_username} --key-name default --pub-key-path /tmp/${admin_username}.pub

chef-server-ctl org-create ${organization_id} "${organization_name}" --association_user ${admin_username} --filename /tmp/${organization_id}-validator.pem

# Data collector
chef-server-ctl set-secret data_collector token ${automate_api_token}
chef-server-ctl restart nginx
chef-server-ctl restart opscode-erchef
echo "Running final chef-server-ctl reconfigure.."
chef-server-ctl reconfigure >/dev/null 2>&1
echo "Done"

# JC-  Don't install manage
#chef-server-ctl install chef-manage
#chef-server-ctl reconfigure
#chef-manage-ctl reconfigure --accept-license

echo "Finished"