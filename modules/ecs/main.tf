resource "aws_ecs_cluster" "cluster" {
  name = "terraform-cluster-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  for_each           = var.app_service
  family             = "${var.app_name}-tf"
  network_mode       = "awsvpc"
  cpu                = each.value.cpu
  memory             = each.value.memory
  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = each.value.name
      image     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.app_name}:latest"
      essential = true
      portMappings = [
        {
          containerPort = each.value.container_port
          hostPort      = each.value.host_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${each.value["name"]}-logs"
          awslogs-region        = var.region
          awslogs-stream-prefix = var.app_name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "fastapp" {
  for_each            = var.app_service
  name                = "${each.value.name}-service"
  launch_type         = "FARGATE"
  cluster             = aws_ecs_cluster.cluster.id
  task_definition     = aws_ecs_task_definition.task_definition[each.key].arn
  desired_count       = each.value.desired_count
  scheduling_strategy = "REPLICA"

  depends_on = [aws_ecs_task_definition.task_definition]
  count      = length(var.public_subnets_ids)

  load_balancer {
    target_group_arn = var.target_group_arn
    container_port   = each.value.container_port
    container_name   = each.value.name
  }

  network_configuration {
    subnets          = element(var.public_subnets_ids, count.index)
    security_groups  = var.security_groups_ids
    assign_public_ip = true
  }
}

resource "aws_appautoscaling_target" "autoscaling_group" {
  for_each           = var.app_service
  max_capacity       = each.value.autoscaling.max_capacity
  min_capacity       = each.value.autoscaling.min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.fastapp[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  for_each           = var.app_service
  name               = "${var.app_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_group.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_group.scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_group.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = each.value.autoscaling.cpu.target_value
  }
}
