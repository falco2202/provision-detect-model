output "vpc_id" {
  value       = module.networking.vpc_id
  description = "VPC id"
}

output "public_subnets_id" {
  value       = module.networking.public_subnets_id
  description = "Subnets"
}

output "security_groups_ids" {
  value       = module.networking.security_groups_ids
  description = "SG"
}

output "public_route_table" {
  value       = module.networking.public_route_table
  description = "Route table"
}

output "ecs_service" {
  value       = module.ecs.ecs_service
  description = "ECS service"
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "dns_app_lb" {
  value = module.alb.app_lb[0].dns_name
}

output "reoute53_record" {
  value = module.route53.reoute53_record
}

