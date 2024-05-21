output "pki_cert" {
  value = {
    ca   = var.ca.ca
    cert = tls_locally_signed_cert.leaf.cert_pem
    key  = tls_private_key.key.private_key_pem
  }
}
