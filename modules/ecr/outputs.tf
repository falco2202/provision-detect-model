output "repository_url" {
  value = aws_ecr_repository.detect_repo.repository_url
}

output "repository_url_id" {
  value = data.aws_ecr_image.detect_repo.id
}
