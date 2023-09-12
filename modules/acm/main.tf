resource "aws_acm_certificate" "falcodev_cert" {
  domain_name       = "api-dev.falcodev.online"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "falcodev" {
  name    = tolist(aws_acm_certificate.falcodev_cert.domain_validation_options)[0].resource_record_name
  type    = "CNAME"
  zone_id = var.zone_id
  records = ["${tolist(aws_acm_certificate.falcodev_cert.domain_validation_options)[0].resource_record_value}"]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.falcodev_cert.arn
  validation_record_fqdns = ["${tolist(aws_acm_certificate.falcodev_cert.domain_validation_options)[0].resource_record_name}"]
}
