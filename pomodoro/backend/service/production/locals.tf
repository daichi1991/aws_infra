#----------
# cloudwatch
#----------
locals {
  container_names = ["web", "proxy", "log_router"]
}

# locals {
#   ops_slack_alert_arn = data.aws_sns_topic.cto_alert_emap_pomodoro_backend.arn
# }

locals {
  prod_pomodoro_backend_cluster_hardlimit = {
    cpu_usage = {
      title         = "prod-pomodoro-backend-cluster-hardlimit-cpuutilized"
      metric_name_1 = "CpuReserved"
      metric_name_2 = "CpuUtilized"
      stat          = "Average"
      //yaxis_label   = "Percent"
    }
    memory_usage = {
      title         = "prod-pomodoro-backend-cluster-hardlimit-momoryutilized"
      metric_name_1 = "MemoryReserved"
      metric_name_2 = "MemoryUtilized"
      stat          = "Average"
      //yaxis_label   = "Percent"
    }
    disk_usage = {
      title         = "prod-pomodoro-backend-cluster-hardlimit-diskspace"
      metric_name_1 = "EphemeralStorageReserved"
      metric_name_2 = "EphemeralStorageUtilized"
      stat          = "Maximum"
      //yaxis_label   = "Gigabytes"
    }
  }
}

locals {
  prod_pomodoro_backend_cluster_metrics_data = {
    task_count = {
      region    = "ap-northeast-1"
      title     = "prod-pomodoro-backend-cluster-task-count"
      threshold = "2"
      metrics = [
        ["ECS/ContainerInsights", "TaskCount", "ClusterName", "prod-pomodoro-backend", { stat = "Average", region = "ap-northeast-1" }]
      ]
    }
    service_count = {
      region    = "ap-northeast-1"
      title     = "prod-pomodoro-backend-cluster-service-count"
      threshold = "1"
      metrics = [
        ["ECS/ContainerInsights", "ServiceCount", "ClusterName", "prod-pomodoro-backend", { stat = "Average", region = "ap-northeast-1" }]
      ]
    }
  }
}

locals {
  codebuild_environment_variables = {
    aws_region_name = {
      name  = "AWS_REGION_NAME"
      value = "ap-northeast-1"
      type  = "PLAINTEXT"
    }
    ecr_repository_name = {
      name  = "ECR_REPOSITORY_NAME"
      value = data.aws_ecr_repository.pomodoro_backend.name
      type  = "PLAINTEXT"
    }
    docker_buildkit = {
      name  = "DOCKER_BUILDKIT"
      value = "1"
      type  = "PLAINTEXT"
    }
    aws_account_id = {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
      type  = "PLAINTEXT"
    }
    target_branch = {
      name  = "TARGET_BRANCH"
      value = "main"
      type  = "PLAINTEXT"
    }
    rails_env = {
      name  = "RAILS_ENV"
      value = "production"
      type  = "PLAINTEXT"
    }
    target_environment = {
      name  = "TARGET_ENVIRONMENT"
      value = "production"
      type  = "PLAINTEXT"
    }
    // NOTE: CodeBuildで作成されるタスク定義はterraform管理のrevisionを基に作るように修正
    task_definition = {
      name  = "TASK_DEFINITION"
      value = "${aws_ecs_task_definition.prod_pomodoro_backend.family}:${aws_ecs_task_definition.prod_pomodoro_backend.revision}"
      type  = "PLAINTEXT"
    }
  }
}

// リビジョン番号を削除
locals {
  task_definition_arn_without_revision = replace(
    aws_ecs_task_definition.prod_pomodoro_backend.arn, "/:[0-9]+$/", ""
  )
}

locals {
  #----------
  # rds
  #----------
  seacretsmanager_name = "prod-pomodoro-db"
  db_name              = "prod_pomodoro"
  user_name            = "postgresmaster"
  #----------
  # tag
  #----------
  common_name = "pomodoro-backend"
}

# #----------
# # wafcharm
# #----------
# locals {
#   alb_access_logs_path               = "${data.aws_s3_bucket.pomodoro_backend.arn}/production/AWSLogs"
#   wafcharm_iam_role_name             = "prod-pomodoro-backend-wafcharm"
#   wafcharm_sts_external_id           = "=TiPsCUa4gEO"
#   wafcharm_waf_acl_name              = "prod-pomodoro-backend"
#   wafcharm_waf_logs_bucket_name      = "aws-waf-logs-prod-pomodoro-backend" # must start with "aws-waf-logs-"
#   wafcharm_waf_metric_name           = "waf-prod-pomodoro-backend"
#   wafcharm_waf_resource_arn          = aws_lb.prod_pomodoro_backend_lb.arn
#   wafcharm_lambda_function_name      = "prod-pomodoro-backend-wafcharm-waflog"
#   wafcharm_lambda_role_name          = "prod-pomodoro-backend-wafcharm-lambda"
#   wafcharm_invocations_alarm_name    = "prod-pomodoro-backend-wafcharm-lambda-invocations"
#   wafcharm_error_rate_alarm_name     = "prod-pomodoro-backend-wafcharm-lambda-error-rate"
#   wafcharm_alert_sns_topic_arn       = data.aws_sns_topic.cto_alert_emap_pomodoro_backend.arn
#   wafcharm_cloudwatch_dashboard_name = "prod-pomodoro-backend-wafcharm"
# }
