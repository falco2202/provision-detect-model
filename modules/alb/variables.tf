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

variable "app_name" {
  type = string
}

variable "env" {
  type = string
}

variable "certificate_arn" {
  type = string
}
