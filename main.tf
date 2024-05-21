resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "req" {
  private_key_pem = tls_private_key.key.private_key_pem

  dns_names = var.dns_names

  dynamic "subject" {
    for_each = [var.subject]
    content {
      common_name         = var.subject.common_name
      country             = var.subject.country
      locality            = var.subject.locality
      organization        = var.subject.organization
      organizational_unit = var.subject.organizational_unit
      postal_code         = var.subject.postal_code
      province            = var.subject.province
      serial_number       = var.subject.serial_number
    }
  }
}


resource "tls_locally_signed_cert" "leaf" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
  is_ca_certificate  = false
  ca_cert_pem        = var.ca.cert
  ca_private_key_pem = var.ca.key
  cert_request_pem   = tls_cert_request.req.cert_request_pem
  # 5 year validity
  validity_period_hours = var.validity_in_hours
}
