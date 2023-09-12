resource "aws_acm_certificate" "falcodev_cert" {
  domain_name       = "api-dev.falcodev.online"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "falcodev" {
  name    = "_acm-validation.falcodev.online"
  type    = "CNAME"
  zone_id = var.zone_id

  records = ["api-dev.falcodev.online"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "falcodev_cert" {
  certificate_arn         = aws_acm_certificate.falcodev_cert.arn
  validation_record_fqdns = [aws_route53_record.falcodev.fqdn]
}
