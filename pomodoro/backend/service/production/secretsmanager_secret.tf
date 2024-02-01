resource "aws_secretsmanager_secret" "prod_pomodoro_backend_application_secret" {
  name        = "prod-pomodoro-backend-application-secret"
  description = "prod-pomodoro-backend application secret"
  kms_key_id  = aws_kms_key.prod_pomodoro_backend_secrets_manager.arn
}

resource "aws_secretsmanager_secret_version" "prod_pomodoro_backend_application_secret_version" {
  secret_id     = aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.id
  secret_string = jsonencode({})

  lifecycle {
    ignore_changes = [
      # NOTE: アプリの管理する秘匿情報の内容はインフラコードでは管理しない
      secret_string
    ]
  }
}

resource "aws_secretsmanager_secret" "prod_pomodoro_db" {
  name = local.seacretsmanager_name
  tags = {
    Name = local.seacretsmanager_name
  }
}

resource "aws_secretsmanager_secret_version" "prod_pomodoro_db" {
  secret_id = aws_secretsmanager_secret.prod_pomodoro_db.id
  secret_string = jsonencode({
    host     = aws_db_instance.prod_pomodoro.address
    port     = aws_db_instance.prod_pomodoro.port
    username = local.user_name
    dbname   = local.db_name
    password = random_password.prod_pomodoro_backend.result
    engine   = "postgres"
  })
}

resource "aws_secretsmanager_secret_policy" "prod_pomodoro_db" {
  secret_arn = aws_secretsmanager_secret.prod_pomodoro_db.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "secretsmanager:DeleteSecret"
        Resource = "*"
      },
    ]
  })
}
