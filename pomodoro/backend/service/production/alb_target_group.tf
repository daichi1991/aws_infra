resource "aws_alb_target_group" "prod_pomodoro_backend_blue" {
  name                 = "prod-pomodoro-backend-blue"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.pomodoro.id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 15
    matcher             = 200
  }
}

resource "aws_alb_target_group" "prod_pomodoro_backend_green" {
  name                 = "prod-pomodoro-backend-green"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.pomodoro.id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    protocol            = "HTTP"
    path                = "/healthcheck"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 15
    matcher             = 200
  }
}
