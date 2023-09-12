resource "aws_lb" "app_lb" {
  count              = length(var.public_subnets_ids)
  name               = "${var.app_name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_ids
  subnets            = element(var.public_subnets_ids, count.index)
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.app_name}-${var.env}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    path     = "/"
  }

  depends_on = [aws_lb.app_lb]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb[0].id
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.app_lb[0].id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
