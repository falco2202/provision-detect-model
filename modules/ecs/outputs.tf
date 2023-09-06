output "ecs_service" {
  value = aws_ecs_service.fastapp.*.id
}
