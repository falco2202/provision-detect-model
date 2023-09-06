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