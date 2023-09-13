provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "networking" {
  source                    = "../../modules/networking"
  name                      = "VPC"
  availability_zones        = var.availability_zones
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnets_cidr_block = var.public_subnets_cidr_block
}

module "ecr" {
  source     = "../../modules/ecr"
  account_id = local.account_id
  region     = var.region
  name_repo  = var.name_repo
  access_id  = var.access_id
  access_key = var.access_key
}

module "acm" {
  source       = "../../modules/acm"
  host_zone_id = var.host_zone_id
  domain_name  = var.record_domain
}

module "alb" {
  source              = "../../modules/alb"
  vpc_id              = module.networking.vpc_id
  security_groups_ids = module.networking.security_groups_ids
  public_subnets_ids  = [module.networking.public_subnets_id]
  app_name            = var.app_name
  env                 = var.env
  certificate_arn     = module.acm.certificate_arn
}

module "route53" {
  source        = "../../modules/route53"
  app_lb        = module.alb.app_lb
  host_zone_id  = var.host_zone_id
  record_domain = var.record_domain
}

module "ecs" {
  source              = "../../modules/ecs"
  depends_on          = [module.networking, module.ecr]
  account_id          = local.account_id
  ecr_repository      = module.ecr.repository_url
  ecr_repository_id   = module.ecr.repository_url_id
  app_name            = var.app_name
  region              = var.region
  app_service         = var.app_service
  env                 = var.env
  vpc_id              = module.networking.vpc_id
  security_groups_ids = module.networking.security_groups_ids
  public_subnets_ids  = module.networking.public_subnets_id
  target_group_arn    = module.alb.target_group_arn
}
