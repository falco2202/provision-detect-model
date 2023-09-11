variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "security_groups_ids" {
  description = "SG id"
}

variable "public_subnets_ids" {
  description = "Subnets"
}

variable "target_group_arn" {
  description = "Target group"
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "app_name" {
  type = string
}

variable "app_service" {
  type = map(object({
    name          = string
    hostPort      = number
    containerPort = number
    cpu           = number
    memory        = number
    desired_count = number

    autoscaling = object({
      max_capacity = number
      min_capacity = number
      cpu = object({
        target_value = number
      })
    })
  }))
}
