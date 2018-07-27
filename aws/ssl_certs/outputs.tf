output "chef_automate_private_key_pem" {
    value = "${tls_private_key.chef_automate.private_key_pem}"
}

output "chef_automate_cert_pem" {
    value = "${tls_self_signed_cert.chef_automate.cert_pem}"
}
