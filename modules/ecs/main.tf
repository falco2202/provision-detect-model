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

  load_balancer {
    target_group_arn = var.target_group_arn
    container_port   = 80
    container_name   = "detect-first"
  }

  network_configuration {
    subnets          = element(var.public_subnets_ids, count.index)
    security_groups  = var.security_groups_ids
    assign_public_ip = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  max_size           = 5
  min_size           = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.fastapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_autoscaling_policy" "ecs_policy" {
  name                   = "cpu-autoscaling"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  cooldown               = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70
  }
}
