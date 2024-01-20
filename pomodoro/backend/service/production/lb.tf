resource "aws_lb" "prod_pomodoro_backend_lb" {
  name               = "prod-pomodoro-backend-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.prod_pomodoro_backend_alb.id]
  subnets = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_c.id,
  ]
  ip_address_type = "ipv4"
  idle_timeout = 120

  access_logs {
    bucket  = "pomodoro-backend"
    prefix  = "production"
    enabled = true
  }

  tags = {
    Name = "prod-${local.common_name}"
  }
}

// blue
resource "aws_alb_listener" "prod_pomodoro_backend_blue_http" {
  load_balancer_arn = aws_lb.prod_pomodoro_backend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "prod_pomodoro_backend_blue_https" {
  load_balancer_arn = aws_lb.prod_pomodoro_backend_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.pomodoro.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.prod_pomodoro_backend_blue.arn
  }

  lifecycle {
    ignore_changes = [
      # NOTE: target_groupはデプロイのたびにblue<->greenが入れ替わる
      default_action["target_group_arn"]
    ]
  }
}

// green
resource "aws_alb_listener" "prod_pomodoro_backend_green_https" {
  load_balancer_arn = aws_lb.prod_pomodoro_backend_lb.arn
  port              = 8080
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.pomodoro.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.prod_pomodoro_backend_green.arn
  }

  lifecycle {
    ignore_changes = [
      # NOTE: target_groupはデプロイのたびにblue<->greenが入れ替わる
      default_action["target_group_arn"]
    ]
  }
}
