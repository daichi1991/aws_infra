resource "aws_db_subnet_group" "prod_pomodoro_backend_datastore" {
  name = "prod_pomodoro_datastore"
  subnet_ids = [
    aws_subnet.prod_pomodoro_backend["private-1a"].id,
    aws_subnet.prod_pomodoro_backend["private-1c"].id,
  ]

  tags = {
    Name        = "prod-pomodoro-datastore"
    Environment = "production"
  }
}
