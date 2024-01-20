resource "aws_ecs_cluster" "prod_pomodoro_backend" {
  name = "prod-pomodoro-backend"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.name
        s3_bucket_name = data.aws_s3_bucket.pomodoro_backend.id
        s3_key_prefix  = "production/ecs_execute_command/"
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "prod_pomodoro_backend" {
  cluster_name = aws_ecs_cluster.prod_pomodoro_backend.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
}
