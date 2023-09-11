terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
  }

  backend "s3" {
    bucket  = "infra-ecs-keypoint"
    key     = "prod/infra.tfstate"
    region  = "ap-southeast-1"
    encrypt = "true"
  }
}
