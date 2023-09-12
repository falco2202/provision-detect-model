output "zone_id" {
  value = aws_route53_zone.falcodev.zone_id
}

output "reoute53_record" {
  value = aws_route53_record.alias_falcodev
}
