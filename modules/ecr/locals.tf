locals {
  app_dir             = "app"
  account_id          = data.aws_caller_identity.current.account_id
  ecr_repository_name = "detect-fastapi"
  ecr_image_tag       = "latest"
}
