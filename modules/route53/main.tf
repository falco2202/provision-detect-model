resource "aws_route53_zone" "falcodev" {
  name = "falcodev.online"
}

resource "aws_route53_record" "alias_falcodev" {
  zone_id = aws_route53_zone.falcodev.zone_id
  name    = "api-dev.falcodev.online"
  type    = "A"

  alias {
    name                   = var.aws_lb.dns_name
    zone_id                = var.aws_lb.zone_id
    evaluate_target_health = true
  }
}
