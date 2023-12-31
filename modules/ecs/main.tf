resource "aws_ecs_cluster" "cluster" {
  name = "terraform-cluster-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family             = "${var.app_name}-tf"
  network_mode       = "awsvpc"
  cpu                = var.app_service.cpu
  memory             = var.app_service.memory
  execution_role_arn = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = var.app_service.name
      image     = "${var.ecr_repository}@${var.ecr_repository_id}"
      essential = true
      portMappings = [
        {
          containerPort = var.app_service.container_port
          hostPort      = var.app_service.host_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "fastapp" {
  name                = "${var.app_service.name}-service"
  launch_type         = "FARGATE"
  cluster             = aws_ecs_cluster.cluster.id
  task_definition     = aws_ecs_task_definition.task_definition.arn
  desired_count       = var.app_service.desired_count
  scheduling_strategy = "REPLICA"

  depends_on = [aws_ecs_task_definition.task_definition]

  load_balancer {
    target_group_arn = var.target_group_arn
    container_port   = var.app_service.container_port
    container_name   = var.app_service.name
  }

  network_configuration {
    subnets          = var.public_subnets_ids
    security_groups  = var.security_groups_ids
    assign_public_ip = true
  }
}

resource "aws_appautoscaling_target" "autoscaling_group" {
  max_capacity       = var.app_service.autoscaling.max_capacity
  min_capacity       = var.app_service.autoscaling.min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.fastapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "${var.app_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_group.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_group.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_group.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.app_service.autoscaling.cpu.target_value
  }
}
