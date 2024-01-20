resource "random_password" "prod_pomodoro_backend" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}