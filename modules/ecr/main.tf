resource "aws_ecr_repository" "detect_repo" {
  name = var.name_repo
}

resource "null_resource" "detect_repo" {
  triggers = {
    app_file    = md5(file("../../detection-model/app/main.py"))
    docker_file = md5(file("../../detection-model/Dockerfile"))
  }
  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.${var.region}.amazonaws.com
      cd ..
      cd .. 
      cd detection-model
      docker build -build-arg ACCESS_KEY=${var.access_id} -build-arg SECRET_ACCESS=${var.access_key} -t ${aws_ecr_repository.detect_repo.repository_url} .
      docker push ${aws_ecr_repository.detect_repo.repository_url}:latest
    EOF
  }
}

data "aws_ecr_image" "detect_repo" {
  depends_on      = [null_resource.detect_repo]
  repository_name = var.name_repo
  image_tag       = "latest"
}
