provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "iam" {
  source   = "./modules/iam"
  app_name = var.app_name
}

module "networking" {
  source                    = "./modules/networking"
  app_name                  = var.app_name
  env                       = var.env
  availability_zones        = var.availability_zones
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnets_cidr_block = var.public_subnets_cidr_block
}

module "ecr" {
  source = "./modules/ecr"
  region = var.region
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.networking.vpc_id
  security_groups_ids = module.networking.security_groups_ids
  public_subnets_ids  = module.networking.public_subnets_id
}

module "ecs" {
  source                      = "./modules/ecs"
  depends_on                  = [module.networking, module.ecr]
  account_id                  = local.account_id
  app_name                    = var.app_name
  region                      = var.region
  env                         = var.env
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  vpc_id                      = module.networking.vpc_id
  security_groups_ids         = module.networking.security_groups_ids
  public_subnets_ids          = module.networking.public_subnets_id
  target_group_arn            = module.alb.target_group_arn
}
