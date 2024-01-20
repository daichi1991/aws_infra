resource "aws_codedeploy_deployment_group" "prod_pomodoro_backend" {
  deployment_group_name  = "prod-pomodoro-backend"
  app_name               = "pomodoro-backend" // NOTE: リソースはcommon参照。dataで参照できないのでコメントのみ記載。
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.prod_pomodoro_backend_codedeploy_service_role.arn

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 30
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.prod_pomodoro_backend.name
    service_name = aws_ecs_service.prod_pomodoro_backend.name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_alb_target_group.prod_pomodoro_backend_blue.name
      }
      prod_traffic_route {
        listener_arns = [
          aws_alb_listener.prod_pomodoro_backend_blue_https.arn,
        ]
      }

      target_group {
        name = aws_alb_target_group.prod_pomodoro_backend_green.name
      }
      test_traffic_route {
        listener_arns = [
          aws_alb_listener.prod_pomodoro_backend_green_https.arn,
        ]
      }
    }
  }
}
