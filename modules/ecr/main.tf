data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "ecr_repository" {
  name = local.ecr_repository_name
}

