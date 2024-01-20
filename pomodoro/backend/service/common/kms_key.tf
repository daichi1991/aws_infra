resource "aws_kms_key" "pomodoro_backend" {
  description         = "pomodoro_backend"
  key_usage           = "ENCRYPT_DECRYPT"
  is_enabled          = true
  enable_key_rotation = false
}

resource "aws_kms_alias" "pomodoro_backend" {
  name          = "alias/pomodoro_backend"
  target_key_id = aws_kms_key.pomodoro_backend.key_id
}