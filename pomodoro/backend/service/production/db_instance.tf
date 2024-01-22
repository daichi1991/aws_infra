resource "aws_db_instance" "prod_pomodoro_backend" {
  identifier                      = "prod-pomodoro-backend"
  storage_type                    = "gp2"
  ca_cert_identifier              = "rds-ca-2019"
  allocated_storage               = 10
  max_allocated_storage           = 50
  engine                          = "postgres"
  engine_version                  = "16.1"
  instance_class                  = "db.t4g.micro"
  port                            = "5432"
  db_subnet_group_name            = "prod_pomodoro_datastore"
  parameter_group_name            = "pomodoro-backend16"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  kms_key_id                      = data.aws_kms_key.pomodoro_backend.arn
  vpc_security_group_ids          = [aws_security_group.prod_pomodoro_backend_db.id]
  db_name                         = local.db_name
  username                        = local.user_name
  password                        = random_password.prod_pomodoro_backend.result
  maintenance_window              = "tue:19:00-tue:20:00"
  monitoring_role_arn             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/emaccess"
  monitoring_interval             = 60
  backup_retention_period         = 0 // backup planで制御
  storage_encrypted               = true
  multi_az                        = true
  auto_minor_version_upgrade      = false
  allow_major_version_upgrade     = false
  performance_insights_enabled    = true
  copy_tags_to_snapshot           = true
  apply_immediately               = true
  #skip_final_snapshot          = false
  #final_snapshot_identifier    = "lastsnapshot20221122"

  tags = {
    autosleep = "false"
  }
}

# resource "aws_backup_vault" "prod_pomodoro_backend_tokyo" {
#   name = "prod-pomodoro-backend-vault-tokyo"
# }

# resource "aws_backup_vault" "prod_pomodoro_backend_osaka" {
#   provider = aws.osaka
#   name     = "prod-pomodoro-backend-vault-osaka"
# }

# resource "aws_backup_plan" "prod_pomodoro_backend" {
#   name = "prod-pomodoro-backend-plan"

#   rule {
#     rule_name         = "prod-pomodoro-backend-rule"
#     target_vault_name = aws_backup_vault.prod_pomodoro_backend_tokyo.name
#     schedule          = "cron(55 14 * * ? *)" // 23:55UTC+9

#     lifecycle {
#       delete_after = "35"
#     }

#     copy_action {
#       destination_vault_arn = aws_backup_vault.prod_pomodoro_backend_osaka.arn
#       lifecycle {
#         delete_after = "35"
#       }
#     }
#   }
# }

# resource "aws_backup_selection" "prod_pomodoro_backend" {
#   name         = "prod-pomodoro-backend-selection"
#   plan_id      = aws_backup_plan.prod_pomodoro_backend.id
#   iam_role_arn = aws_iam_role.prod_pomodoro_backend_backup.arn

#   resources = [
#     aws_db_instance.prod_pomodoro_backend.arn
#   ]
# }
