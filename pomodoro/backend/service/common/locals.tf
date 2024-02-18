locals {
  repository = {
    pomodoro-backend = "pomodoro_backend"
  }
  ecr = {
    pomodoro-backend = "pomodoro-backend"
  }
  scheduler_schedule_group_name = "scan-ecr"
  #----------
  # rds
  #----------
  seacretsmanager_name = "prod-pomodoro-db"
  db_name              = "prod_pomodoro_backend-dbname"
  user_name            = "postgresmaster"
  s3 = {
    # pomodoro         = "pomodoro"
    pomodoro-backend = "pomodoro-backend"
  }
}

locals {
  basicscan_event_pattern = {
    "source" : ["aws.ecr"],
    "detail-type" : ["ECR Image Scan"],
    "detail" : {
      "repository-name" : ["pomodoro-backend"],
      "scan-status" : ["COMPLETE"],
      "image-tags" : ["main-web-latest", "main-proxy-latest"]
    }
  }
}

locals {
  basicscan_event_schedules = {
    main_web = {
      name              = "scan-ecr-main-web-latest"
      "repository-name" = "pomodoro-backend"
      ImageTag          = "main-web-latest"
    }
    main_proxy = {
      name            = "scan-ecr-main-proxy-latest"
      repository-name = "pomodoro-backend"
      ImageTag        = "main-proxy-latest"
    }
  }
}
