resource "aws_codedeploy_app" "pomodoro_backend" {
  compute_platform = "ECS"
  name             = "pomodoro-backend"
}
