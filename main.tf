provider "aws" {
  region = var.region
}

module "networking" {
  source                    = "./modules/networking"
  name                      = "VPC"
  availability_zones        = var.availability_zones
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnets_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "ecs" {
  source              = "./modules/ecs"
  depends_on          = [module.networking]
  vpc_id              = module.networking.vpc_id
  security_groups_ids = module.networking.security_groups_ids
  public_subnets_ids  = module.networking.public_subnets_id
}