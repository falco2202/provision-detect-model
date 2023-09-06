data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "repository" {
  name = var.ecr_name

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}
