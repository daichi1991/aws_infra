resource "aws_ecs_task_definition" "prod_pomodoro_backend" {
  cpu                = 256   // .25vCPU
  memory             = 512  // 512MiB
  execution_role_arn = aws_iam_role.prod_pomodoro_backend_ecs_task_execution.arn
  family             = "prod-pomodoro-backend"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]

  lifecycle {
    ignore_changes = [
      //container_definitions
    ]
  }
  skip_destroy  = true
  task_role_arn = aws_iam_role.prod_pomodoro_backend_ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64" //ARM64
  }
  container_definitions = jsonencode(
    [
      {
        name      = "log_router"
        image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/pomodoro-backend:main-log_router-latest"
        essential = false
        "portMappings" : [
          {
            "containerPort" : 8081,
            "hostPort" : 8081
            "protocol" : "tcp"
          }
        ],
        firelensConfiguration = {
          type = "fluentbit"
          options = {
            config-file-type = "file"
            # コンテナイメージ内のConfigファイルパス
            config-file-value       = "/fluent-bit/etc/extra/web.conf"
            enable-ecs-log-metadata = "true"
          }
        }
        environment = [
          {
            name  = "RACK_ENV",
            value = "production"
          },
          {
            name  = "RAILS_LOG_TO_STDOUT",
            value = "true"
          },
          {
            name  = "RAILS_SERVE_STATIC_FILES",
            value = "false"
          },
          {
            name  = "AWS_REGION",
            value = data.aws_region.current.name
          },
          {
            name  = "TASK_DEFINITION_CONTAINER_NAME_WEB",
            value = "web"
          },
          {
            name  = "TASK_DEFINITION_CONTAINER_NAME_PROXY",
            value = "proxy"
          },
          {
            name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME",
            value = aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.name
          },
          {
            name = "AWS_CLOUDWATCH_LOG_STREAM_PREFIX",
            value = "ecs/" # 最後に / を付け足すこと
          },
          {
            name  = "AWS_KINESIS_FIREHOSE_DELIVERY_STREAM_NAME_WEB",
            value = var.prod_pomodoro_backend_delivery_streams.web-messages.name
          },
          {
            name  = "AWS_KINESIS_FIREHOSE_DELIVERY_STREAM_NAME_PROXY",
            value = var.prod_pomodoro_backend_delivery_streams.proxy-messages.name
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "ecs"
          }
        },
        cpu         = 0
        mountPoints = []
        user        = "0"
        volumesFrom = []
      },
      {
        name      = "web"
        image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/pomodoro-backend:main-web-latest"
        essential = false
        "portMappings" : [
          {
            "containerPort" : 8082,
            "hostPort" : 8082
            "protocol" : "tcp"
          }
        ],
        environment = [
          {
            name  = "RAILS_ENV"
            value = "production"
          },
        ]
        secrets = [
          {
            name      = "DATABASE_HOST"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_db.arn}:host::"
          },
          {
            name      = "DATABASE_DATABASE"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_db.arn}:dbname::"
          },
          {
            name      = "DATABASE_PASSWORD"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_db.arn}:password::"
          },
          {
            name      = "DATABASE_USER"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_db.arn}:username::"
          },
          {
            name      = "RAILS_MASTER_KEY"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn}:RAILS_MASTER_KEY::"
          },
          {
            name      = "FRONTEND_ORIGIN"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn}:FRONTEND_ORIGIN::"
          },
          {
            name      = "SPOTIFY_CLIENT_ID"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn}:SPOTIFY_CLIENT_ID::"
          },
          {
            name      = "SPOTIFY_CLIENT_SECRET"
            valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn}:SPOTIFY_CLIENT_SECRET::"
          },
          # {
          #   name      = "SECRET_VALUES"
          #   valueFrom = "${aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn}"
          # },
        ]
        logConfiguration = {
          logDriver = "awsfirelens"
        }
        /*"logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-region" : data.aws_region.current.name,
            "awslogs-group" : aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.name,
            "awslogs-stream-prefix" : "ecs"
          }
        }*/
        cpu             = 0
        mountPoints     = []
        volumesFrom     = []
      },
      {
        name      = "proxy"
        image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/pomodoro-backend:main-proxy-latest"
        essential = true
        dependsOn = [
          {
            condition     = "START"
            containerName = "web"
          },
        ]
        environment = [
          {
            name  = "ENABLE_API_DOCS"
            value = "false"
          },
        ]
        logConfiguration = {
          logDriver = "awsfirelens"
        }
        /*"logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-region" : data.aws_region.current.name,
            "awslogs-group" : aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.name,
            "awslogs-stream-prefix" : "ecs"
          }
        }*/
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          },
        ]
        startTimeout = 30
        stopTimeout  = 30
        volumesFrom = [
          {
            sourceContainer = "web"
          },
        ]
        cpu             = 0
        mountPoints     = []
      },
    ]
  )
}
