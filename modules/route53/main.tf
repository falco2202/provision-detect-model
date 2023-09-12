resource "aws_route53_zone" "falcodev" {
  name = var.host_zone
}

resource "aws_route53_record" "alias_falcodev" {
  zone_id = aws_route53_zone.falcodev.zone_id
  name    = var.record_api
  type    = "A"

  alias {
    name                   = var.app_lb.dns_name
    zone_id                = var.app_lb.zone_id
    evaluate_target_health = true
  }
}
