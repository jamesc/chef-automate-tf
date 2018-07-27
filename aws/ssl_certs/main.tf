provider "tls" {

}

// Create some keys if needed
resource "tls_private_key" "chef_automate" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "chef_automate" {
  key_algorithm   = "${tls_private_key.chef_automate.algorithm}"
  private_key_pem = "${tls_private_key.chef_automate.private_key_pem}"

  # Certificate expires after 1 year.
  validity_period_hours = 8760

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  dns_names = ["${var.automate_host_name}.${var.automate_domain_name}"]

  subject {
      common_name  = "${var.automate_domain_name}"
      organization = "${var.automate_domain_name}"
  }

}
