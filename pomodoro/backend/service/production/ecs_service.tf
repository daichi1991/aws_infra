resource "aws_ecs_service" "prod_pomodoro_backend" {
  name                               = "prod-pomodoro-backend"
  cluster                            = aws_ecs_cluster.prod_pomodoro_backend.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  enable_execute_command             = true
  health_check_grace_period_seconds  = 180
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  propagate_tags                     = "SERVICE"
  scheduling_strategy                = "REPLICA"
  task_definition                    = aws_ecs_task_definition.prod_pomodoro_backend.arn

  lifecycle {
    ignore_changes = [
      desired_count,   # Updated possibly by auto scaling
      task_definition, # Updated by deployments
      # NOTE: target_groupはデプロイのたびにblue<->greenが入れ替わる
      #       target_groupだけで良いが、現状target_groupのみをignoreする方法がなさそうなのでload_balancerをまるごとignoreする
      #       See: https://github.com/hashicorp/terraform-provider-aws/issues/13192
      load_balancer,
    ]
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    container_name   = "proxy"
    container_port   = 80
    target_group_arn = aws_alb_target_group.prod_pomodoro_backend_blue.arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.prod_pomodoro_backend_ecs_task.id,
    ]
    subnets = [
      data.aws_subnet.private_a.id,
      data.aws_subnet.private_c.id,
    ]
  }
}
