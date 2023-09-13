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

variable "host_zone_id" {
  type    = string
  default = "Z093024522NNUB959GH4"
}

variable "record_domain" {
  type        = string
  description = "Route 53 record"
}

variable "name_repo" {
  type        = string
  description = "Name repository ECR"
}
