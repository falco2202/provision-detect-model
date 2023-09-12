output "target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}

output "app_lb" {
  value = aws_alb_target_group.alb_target_group
}
