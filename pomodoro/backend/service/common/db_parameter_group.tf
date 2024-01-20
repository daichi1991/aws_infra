resource "aws_db_parameter_group" "pomodoro_backend" {
  name   = "pomodoro-backend16"
  family = "postgres16"

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000" //msec
  }
}
