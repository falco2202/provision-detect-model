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

variable "region" {
  type = string
}

variable "ecr_repository" {
  type = string
}

variable "app_name" {
  type = string
}

variable "account_id" {
  type = number
}

variable "env" {
  type = string
}

variable "app_service" {
  type = object({
    name           = string
    host_port      = number
    container_port = number
    cpu            = number
    memory         = number
    desired_count  = number

    autoscaling = object({
      max_capacity = number
      min_capacity = number
      cpu = object({
        target_value = number
      })
    })
  })
}
