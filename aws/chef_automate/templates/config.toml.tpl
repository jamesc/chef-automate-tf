# This is a default Chef Automate configuration file. You can run
# 'chef-automate deploy' with this config file and it should
# successfully create a new Chef Automate instance with default settings.

[global.v1]
  # The external fully qualified domain name.
  # When the application is deployed you should be able to access 'https://<fqdn>/'
  # to login.
  fqdn = "${host_name}.${domain_name}"

# Deployment service configuration.
[deployment.v1]
  [deployment.v1.svc]
    # Habitat channel to install hartifact from.
    # Can be 'dev', 'current', or 'acceptance'
    channel = "current"
    upgrade_strategy = "at-once"
    deployment_type = "local"
    [deployment.v1.svc.admin_user]
      # Default admin user settings
      email = "${admin_email}"
      username = "${admin_username}"
      password = "${admin_password}"

# Load Balancer service configuration.
[load_balancer]
  [load_balancer.v1.sys]
    [[load_balancer.v1.sys.frontend_tls]]
      # The TLS certificate for the load balancer frontend.
      cert ="""
${frontend_cert}
"""
      # The TLS RSA key for the load balancer frontend.
      key = """
${frontend_key}
"""

# License Control service configuration.
[license_control.v1]
  [license_control.v1.svc]
    # The Chef Software provided license token required to run Chef Automate.
    # This can also be set with the "chef-automate license apply" command.
    license = "${automate_license}"