resource "aws_ecs_cluster" "cluster" {
  name = "TerraformCluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family             = "detect-fargate-tf"
  network_mode       = "awsvpc"
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = "arn:aws:iam::762317700000:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "detect-first"
      image     = "762317700000.dkr.ecr.ap-southeast-1.amazonaws.com/fastapp:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "fastapp" {
  name                = "fastapp"
  launch_type         = "FARGATE"
  cluster             = aws_ecs_cluster.cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  desired_count       = 1
  scheduling_strategy = "REPLICA"

  depends_on = [aws_ecs_task_definition.task_definition]
  count      = length(var.public_subnets_ids)

  network_configuration {
    subnets          = element(var.public_subnets_ids, count.index)
    security_groups  = var.security_groups_ids
    assign_public_ip = true
  }
}
