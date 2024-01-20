resource "aws_cloudwatch_log_group" "ecs_prod_pomodoro_backend" {
  name              = "/ecs/prod-pomodoro-backend"
  skip_destroy      = false
  retention_in_days = 3
}
