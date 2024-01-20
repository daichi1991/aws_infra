resource "aws_kinesis_firehose_delivery_stream" "prod_pomodoro_backend_delivery_stream" {
  for_each = var.prod_pomodoro_backend_delivery_streams

  name        = each.value.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.prod_pomodoro_backend_ecs_task.arn
    buffering_interval = "300"
    buffering_size     = "5"
    bucket_arn         = "arn:aws:s3:::pomodoro-backend"
    prefix             = each.value.prefix
  }
}
