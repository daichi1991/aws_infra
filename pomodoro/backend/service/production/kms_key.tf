resource "aws_kms_key" "prod_pomodoro_backend_secrets_manager" {
  description         = "prod_pomodoro_backend_secrets_manager"
  key_usage           = "ENCRYPT_DECRYPT"
  is_enabled          = true
  enable_key_rotation = false
}

resource "aws_kms_alias" "prod_pomodoro_backend_secrets_manager" {
  name          = "alias/prod_pomodoro_backend_secrets_manager"
  target_key_id = aws_kms_key.prod_pomodoro_backend_secrets_manager.key_id
}
