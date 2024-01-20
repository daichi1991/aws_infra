resource "aws_codestarconnections_connection" "pomodoro_backend" {
  for_each      = local.repository
  name          = each.value
  provider_type = "GitHub"
}
