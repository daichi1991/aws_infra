data "aws_canonical_user_id" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# data "aws_sns_topic" "cto_alert_emap_pomodoro_backend" {
#   name = "cto-alert-emap-pomodoro-backend"
# }

data "aws_iam_policy" "awswaffullaccess" {
  name = "AWSWAFFullAccess"
}

data "aws_vpc" "pomodoro" {
  tags = {
    Name = "pomodoro"
  }
}

data "aws_acm_certificate" "pomodoro" {
  domain = "pomo-sync-sounds.com"
}

data "aws_s3_bucket" "pomodoro_backend" {
  bucket = "pomodoro-backend"
}

data "aws_codestarconnections_connection" "pomodoro_backend" {
  name = "pomodoro_backend"
}

data "aws_ecr_repository" "pomodoro_backend" {
  name = "pomodoro-backend"
}

data "aws_ecr_repository" "cloudwatch_agent" {
  name = "cloudwatch-agent"
}

data "aws_kms_key" "pomodoro_backend" {
  key_id = "alias/pomodoro_backend"
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["prod-pomodoro-backend-private-1a"]
  }
}

data "aws_subnet" "private_c" {
  filter {
    name   = "tag:Name"
    values = ["prod-pomodoro-backend-private-1c"]
  }
}

data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = ["prod-pomodoro-backend-public-1a"]
  }
}

data "aws_subnet" "public_c" {
  filter {
    name   = "tag:Name"
    values = ["prod-pomodoro-backend-public-1c"]
  }
}

data "aws_route53_zone" "pomdoro_com_zone" {
  name = "pomo-sync-sounds.com"
}

data "aws_iam_role" "pomodoro_backend_ecs_task_execution" {
  name = "pomodoro-backend-ecs-task-execution"
}
