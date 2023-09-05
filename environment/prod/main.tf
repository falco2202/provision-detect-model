provider "aws" {
  region = var.region
}

module "networking" {
  source             = "../../modules/networking"
  name               = "VPC"
  availability_zone  = var.availability_zones
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets_cidr_block = ["10.0.1.0/24","10.0.2.0/24"]
}