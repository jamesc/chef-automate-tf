chef_server_url "https://${host_name}.${domain_name}/organizations/${organization_id}"
client_key "client.pem"
node_name "${admin_username}"

ssl_verify_mode ':none'
