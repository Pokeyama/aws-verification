# 証明書アップロード
resource "aws_acm_certificate" "hirayama_cert" {
  certificate_chain = file("hirayama.crt")
  certificate_body  = file("hirayama.pem")
  private_key       = file("hirayama.key")

  tags = {
    Name = "hirayama-ssl"
  }
}

# 全自動証明書発行 危ないからヤメましょう
# resource "tls_private_key" "https_test_root" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "https_test_root" {
#   key_algorithm   = "${tls_private_key.https_test_root.algorithm}"
#   private_key_pem = "${tls_private_key.https_test_root.private_key_pem}"

#   subject {
#     common_name  = "HTTPS_TEST_ROOT"
#   }

#   validity_period_hours = 87600

#   is_ca_certificate = true

#   allowed_uses = [
#    "digital_signature",
#    "crl_signing",
#    "cert_signing",
#   ]
# }

# resource "local_file" "https_test_root_key" {
#   filename = "https_test_root.key"
#   content  = "${tls_private_key.https_test_root.private_key_pem}"
# }

# resource "local_file" "https_test_root_pem" {
#   filename = "https_test_root.crt"
#   content  = "${tls_self_signed_cert.https_test_root.cert_pem}"
# }

# resource "tls_private_key" "https_test" {
#   algorithm = "RSA"
# }

# resource "tls_cert_request" "https_test" {
#   key_algorithm   = "${tls_private_key.https_test.algorithm}"
#   private_key_pem = "${tls_private_key.https_test.private_key_pem}"

#   subject {
#     common_name  = "*.ap-northeast-1.elb.amazonaws.com"
#   }

#   dns_names = [
#     "*.ap-northeast-1.elb.amazonaws.com",
#   ]
# }

# resource "tls_locally_signed_cert" "https_test" {
#   cert_request_pem   = "${tls_cert_request.https_test.cert_request_pem}"

#   ca_key_algorithm   = "${tls_private_key.https_test_root.algorithm}"
#   ca_private_key_pem = "${tls_private_key.https_test_root.private_key_pem}"
#   ca_cert_pem        = "${tls_self_signed_cert.https_test_root.cert_pem}"

#   validity_period_hours = 87600

#   is_ca_certificate = false
#   set_subject_key_id = true

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#     "client_auth",
#   ]
# }

# resource "local_file" "https_test_key" {
#   filename = "https_test.key"
#   content  = "${tls_private_key.https_test.private_key_pem}"
# }

# resource "local_file" "https_test_cert_pem" {
#   filename = "https_test_cert.pem"
#   content  = "${tls_locally_signed_cert.https_test.cert_pem}"
# }

# # ACMにアタッチ
# resource "aws_acm_certificate" "https_test" {
#   private_key       = "${tls_private_key.https_test.private_key_pem}"
#   certificate_body  = "${tls_locally_signed_cert.https_test.cert_pem}"
#   certificate_chain = "${tls_self_signed_cert.https_test_root.cert_pem}"

#   tags = {
#     Name = "hirayama-acm"
#   }
# }