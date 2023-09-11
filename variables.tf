### Common variables
variable "region" {
  type        = string
  description = "AWS region"
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "env" {
  type        = string
  description = "Environment"
}

### VPC variables
variable "vpc_cidr_block" {
  type = string
}
variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that the services are running"
}

variable "public_subnets_cidr_block" {
  type = list(string)
}

### Service variables
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
