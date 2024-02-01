// rds backup
resource "aws_iam_role" "prod_pomodoro_backend_backup" {
  name = "prod-pomodoro-backend-backup"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_backup_selection" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.prod_pomodoro_backend_backup.id
}

# eventbridge
resource "aws_iam_role" "prod_pomodoro_backend_ecs_events" {
  name = "prod-pomodoro-backend-ecs-events"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "events.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "prod_vpomodoro_backend_ecs_events" {
  name = "prod-pomodoro-backend-ecs-events"
  role = aws_iam_role.prod_pomodoro_backend_ecs_events.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecs:RunTask",
          "ecs:StopTask",
          "ecs:DescribeTasks",
        ],
        "Resource" : "*",
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
      },
      {
        "Effect" : "Allow",
        "Action" : "ecs:TagResource",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "ecs:CreateAction" : [
              "RunTask",
              "StopTask",
              "DescribeTasks",
            ]
          }
        }
      }
    ]
  })
}

# ECS
# Task
resource "aws_iam_role" "prod_pomodoro_backend_ecs_task" {
  name = "prod-pomodoro-backend-ecs-task"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : [
            "ecs-tasks.amazonaws.com",
            "firehose.amazonaws.com",
          ]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "prod_pomodoro_backend_ecs_task" {
  name = "prod-pomodoro-backend-ecs-task"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ],
        "Resource" : [
          "arn:aws:s3:::pomodoro-backend",
          "arn:aws:s3:::pomodoro-backend/production/*",
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListAllMyBuckets"
        ],
        "Resource" : [
          "arn:aws:s3:::pomodoro-backend",
          "arn:aws:s3:::pomodoro-backend/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "firehose:ListDeliveryStreams",
          "firehose:PutRecord",
          "firehose:PutRecordBatch",
          "firehose:UpdateDestination"
        ],
        "Resource" : "arn:aws:firehose:ap-northeast-1:${data.aws_caller_identity.current.account_id}:deliverystream/*"
      },
      {
        "Action" : [
          "cloudwatch:PutMetricData",
        ]
        "Effect" : "Allow",
        "Resource" : "*",
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "logs:DescribeLogGroups"
        ]
        "Resource" : "*"
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        "Resource" : "${aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.arn}:*"
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "logs:DescribeLogGroups"
        ]
        "Resource" : "*"
      },
      {
        "Effect" : "Allow"
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        "Resource" : "${aws_cloudwatch_log_group.ecs_prod_pomodoro_backend.arn}:*"
      },
      {
        "Action" : [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn,
          aws_secretsmanager_secret.prod_pomodoro_db.arn,
        ]
      },
      {
        "Action" : [
          "kms:Decrypt",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_kms_key.prod_pomodoro_backend_secrets_manager.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_ecs_task" {
  policy_arn = aws_iam_policy.prod_pomodoro_backend_ecs_task.arn
  role       = aws_iam_role.prod_pomodoro_backend_ecs_task.id
}

# ECS
# Task Execution
resource "aws_iam_role" "prod_pomodoro_backend_ecs_task_execution" {
  name = "prod-pomodoro-backend-ecs-task-execution"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "prod_pomodoro_backend_ecs_task_execution" {
  name = "prod-pomodoro-backend-ecs-task-execution"
  path = "/service-role/"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ],
        "Resource" : [
          data.aws_ecr_repository.pomodoro_backend.arn,
          data.aws_ecr_repository.cloudwatch_agent.arn,
          //data.aws_ecr_repository.crowdstrike.arn,
          "arn:aws:ecr:ap-northeast-1:906394416424:repository/aws-for-fluent-bit",
        ]
      },
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ssm:GetParameters",
        ],
        "Effect" : "Allow",
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Resource" : "*"
      },
      {
        "Action" : [
          "ecs:RegisterTaskDefinition",
          "ecs:ListClusters",
          "ecs:ListContainerInstances",
          "ecs:DescribeContainerInstances",
        ]
        "Effect" : "Allow"
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
      {
        "Action" : [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn,
          aws_secretsmanager_secret.prod_pomodoro_db.arn,
        ]
      },
      {
        "Action" : [
          "kms:Decrypt",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_kms_key.prod_pomodoro_backend_secrets_manager.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_ecs" {
  policy_arn = aws_iam_policy.prod_pomodoro_backend_ecs_task_execution.arn
  role       = aws_iam_role.prod_pomodoro_backend_ecs_task_execution.id
}

// codepipeline
resource "aws_iam_role" "prod_pomodoro_backend_codepipeline_service_role" {
  name = "prod-pomodoro-backend-codepipeline-service-role"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "prod_pomodoro_backend_codepipeline" {
  name        = "prod-pomodoro-backend-codepipeline"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      # NOTE: CodeDeployが使用するRoleをPassRoleする
      {
        "Action" : [
          "iam:PassRole",
        ]
        "Condition" : {
          "StringEqualsIfExists" : {
            "iam:PassedToService" : [
              "ecs-tasks.amazonaws.com",
            ]
          }
        }
        "Effect" : "Allow"
        "Resource" : [
          aws_iam_role.prod_pomodoro_backend_ecs_task.arn,
          aws_iam_role.prod_pomodoro_backend_ecs_task_execution.arn,
        ]
      },
      {
        "Action" : [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision",
        ]
        "Effect" : "Allow"
        "Resource" : [
          // NOTE: リソースはcommon参照。dataで参照できないのでコメントのみ記載。
          "arn:aws:codedeploy:ap-northeast-1:${data.aws_caller_identity.current.account_id}:application:pomodoro-backend",
        ]
      },
      {
        "Action" : [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "*", // aws_codedeploy_deployment_group.prod_pomodoro_backend_deployment_group.arn,
        ]
      },
      {
        "Action" : "codedeploy:GetDeploymentConfig"
        "Effect" : "Allow"
        "Resource" : "*" # NOTE: CodeDeployDefault.ECSAllAtOnceだけしか使わないですが、今後変更しやすいように*にします
      },
      {
        "Action" : [
          "codestar-connections:UseConnection",
        ]
        "Effect" : "Allow"
        "Resource" : data.aws_codestarconnections_connection.pomodoro_backend.arn
      },
      {
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "${aws_s3_bucket.prod_pomodoro_backend_pipeline_artifact.arn}/*",
        ]
      },
      {
        "Action" : [
          "ecs:RegisterTaskDefinition",
        ]
        "Effect" : "Allow"
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
      {
        "Action" : [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch",
        ]
        "Effect" : "Allow"
        "Resource" : [
          aws_codebuild_project.prod_pomodoro_backend.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_codepipeline" {
  policy_arn = aws_iam_policy.prod_pomodoro_backend_codepipeline.arn
  role       = aws_iam_role.prod_pomodoro_backend_codepipeline_service_role.id
}

// codebuild
resource "aws_iam_role" "prod_pomodoro_backend_codebuild_service_role" {
  name = "prod-pomodoro-backend-codebuild-service-role"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow"
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_codebuild" {
  policy_arn = aws_iam_policy.prod_pomodoro_backend_codebuild.arn
  role       = aws_iam_role.prod_pomodoro_backend_codebuild_service_role.id
}

resource "aws_iam_policy" "prod_pomodoro_backend_codebuild" {
  name        = "prod-pomodoro-backend-codebuild"
  description = "Policy used in trust relationship with CodeBuild"
  path        = "/service-role/"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "${aws_s3_bucket.prod_pomodoro_backend_pipeline_artifact.arn}/*",
        ]
      },
      # NOTE: for logging
      {
        "Action" : [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "arn:aws:s3:::pomodoro-backend",
          "arn:aws:s3:::pomodoro-backend/*",
        ]
      },
      {
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "arn:aws:codebuild:ap-northeast-1:${data.aws_caller_identity.current.account_id}:report-group/prod-pomodoro-backend-*",
        ]
      },
      {
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
        ]
        "Effect" : "Allow",
        "Resource" : [
          data.aws_ecr_repository.pomodoro_backend.arn,
        ]
      },
      {
        "Action" : "ecr:GetAuthorizationToken"
        "Effect" : "Allow",
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
      {
        "Action" : [
          "secretsmanager:GetSecretValue",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_secretsmanager_secret.prod_pomodoro_backend_application_secret.arn,
          aws_secretsmanager_secret.prod_pomodoro_db.arn,
        ]
      },
      {
        "Action" : [
          "kms:Decrypt",
        ]
        "Effect" : "Allow",
        "Resource" : [
          aws_kms_key.prod_pomodoro_backend_secrets_manager.arn
        ]
      },
      # NOTE: ビルド時にbuildspec経由で最新のタスク定義を参照しているため
      {
        "Action" : [
          "ecs:DescribeTaskDefinition",
        ]
        "Effect" : "Allow",
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
    ]
  })
}

# CodeDeploy
resource "aws_iam_policy" "prod_pomodoro_backend_codedeploy" {
  name = "prod-pomodoro-backend-codedeploy-policy"
  path = "/service-role/"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ecs:DescribeServices",
          "ecs:UpdateServicePrimaryTaskSet",
        ],
        "Effect" : "Allow",
        "Resource" : aws_ecs_service.prod_pomodoro_backend.id
      },
      {
        "Action" : [
          "ecs:CreateTaskSet",
          "ecs:DeleteTaskSet",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
        "Condition" : {
          "StringLike" : {
            "ecs:service" : aws_ecs_service.prod_pomodoro_backend.id
          }
        }
      },
      {
        "Action" : "cloudwatch:DescribeAlarms",
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Action" : "sns:Publish",
        "Effect" : "Allow",
        "Resource" : "arn:aws:sns:*:*:CodeDeployTopic_*"
      },
      {
        "Action" : "elasticloadbalancing:ModifyListener",
        "Effect" : "Allow",
        "Resource" : [
          aws_alb_listener.prod_pomodoro_backend_blue_https.arn,
          aws_alb_listener.prod_pomodoro_backend_green_https.arn,
        ]
      },
      {
        "Action" : [
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyRule",
        ],
        "Effect" : "Allow",
        "Resource" : "*" # NOTE: リソースレベルのアクセス権限をサポートしていない
      },
      {
        "Action" : "lambda:InvokeFunction",
        "Effect" : "Allow",
        "Resource" : "arn:aws:lambda:*:*:function:CodeDeployHook_*"
      },
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "s3:ExistingObjectTag/UseWithCodeDeploy" : "true"
          }
        }
      },
      {
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
        ]
        "Effect" : "Allow"
        "Resource" : [
          "${aws_s3_bucket.prod_pomodoro_backend_pipeline_artifact.arn}/*",
        ]
      },
      {
        "Action" : [
          "iam:PassRole"
        ],
        "Effect" : "Allow",
        "Resource" : [
          aws_iam_role.prod_pomodoro_backend_ecs_task_execution.arn,
          aws_iam_role.prod_pomodoro_backend_ecs_task.arn
        ],
        "Condition" : {
          "StringLike" : {
            "iam:PassedToService" : [
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_role" "prod_pomodoro_backend_codedeploy_service_role" {
  name = "prod-pomodoro-backend-codedeploy-service-role"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "codedeploy.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_codedeploy" {
  policy_arn = aws_iam_policy.prod_pomodoro_backend_codedeploy.arn
  role       = aws_iam_role.prod_pomodoro_backend_codedeploy_service_role.id
}
/*
resource "aws_iam_role_policy_attachment" "prod_pomodoro_backend_codedeploy2" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
  role       = aws_iam_role.prod_pomodoro_backend_codedeploy_service_role.id
}
*/

// wafcharm
# resource "aws_iam_role" "wafcharm" {
#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Condition = {
#             StringEquals = {
#               "sts:ExternalId" = local.wafcharm_sts_external_id
#             }
#           }
#           Effect = "Allow"
#           Principal = {
#             AWS = [
#               "arn:aws:iam::311635851477:root",
#               "arn:aws:iam::347433978697:root",
#             ]
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )

#   force_detach_policies = false
#   managed_policy_arns   = [data.aws_iam_policy.awswaffullaccess.arn]
#   max_session_duration  = 3600
#   name                  = local.wafcharm_iam_role_name
#   path                  = "/"

#   inline_policy {
#     name = "s3"
#     policy = jsonencode(
#       {
#         Statement = [
#           {
#             Action = [
#               "s3:Get*",
#               "s3:List*",
#             ]
#             Effect = "Allow"
#             Resource = [
#               data.aws_s3_bucket.pomodoro_backend.arn,
#               "${local.alb_access_logs_path}/*",
#             ]
#             Sid = "S3ReadOnly"
#           },
#         ]
#         Version = "2012-10-17"
#       }
#     )
#   }
# }

# ----------------------------
# IAM role for Lambda function
# ----------------------------
# resource "aws_iam_role" "wafcharm_reporting" {
#   assume_role_policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "sts:AssumeRole"
#           Effect = "Allow"
#           Principal = {
#             Service = "lambda.amazonaws.com"
#           }
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )
#   force_detach_policies = false
#   max_session_duration  = 3600
#   name                  = local.wafcharm_lambda_role_name
#   path                  = "/service-role/"

#   inline_policy {
#     name = "logs"
#     policy = jsonencode(
#       {
#         Statement = [
#           {
#             Action = [
#               "logs:CreateLogStream",
#               "logs:PutLogEvents",
#             ]
#             Effect = "Allow"
#             Resource = [
#               "${aws_cloudwatch_log_group.wafcharm_reporting.arn}:*",
#             ]
#           },
#         ]
#         Version = "2012-10-17"
#       }
#     )
#   }

#   inline_policy {
#     name = "wafcharm-waflog-s3-put"
#     policy = jsonencode(
#       {
#         Statement = [
#           {
#             Action = [
#               "s3:PutObject",
#               "s3:PutObjectAcl",
#             ]
#             Effect   = "Allow"
#             Resource = "arn:aws:s3:::wafcharm.com/*" # external bucket
#           },
#         ]
#         Version = "2012-10-17"
#       }
#     )
#   }

#   inline_policy {
#     name = "wafcharm-waflog-s3-read"
#     policy = jsonencode(
#       {
#         Statement = [
#           {
#             Action   = "s3:GetObject"
#             Effect   = "Allow"
#             Resource = "${aws_s3_bucket.wafcharm_reporting.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/WAFLogs/${data.aws_region.current.name}/${aws_wafv2_web_acl.wafcharm.name}/*"
#           },
#         ]
#         Version = "2012-10-17"
#       }
#     )
#   }
# }
