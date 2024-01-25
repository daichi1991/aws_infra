resource "aws_ecr_repository" "pomodoro_backend" {
  name                 = "pomodoro-backend"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.pomodoro_backend.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "pomodoro-backend"
  }
}

resource "aws_ecr_lifecycle_policy" "pomodoro_backend" {
  repository = aws_ecr_repository.pomodoro_backend.name

  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep master/main in 10000 days",
        "selection" : {
          "tagStatus" : "tagged",
          "tagPrefixList" : ["master", "main"],
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 10000
        },
        "action" : {
          "type" : "expire"
        }
      },
      {
        "rulePriority" : 2,
        "description" : "delete image in 90 days",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 90
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "cloudwatch_agent" {
  name                 = "cloudwatch-agent"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.cloudwatch_agent_ecr_repository_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_kms_key" "cloudwatch_agent_ecr_repository_key" {
  description         = "cloudwatch_agent_ecr_repository_key"
  key_usage           = "ENCRYPT_DECRYPT"
  is_enabled          = true
  enable_key_rotation = false
}

resource "aws_kms_alias" "cloudwatch_agent_ecr_repository_key_alias" {
  name          = "alias/cloudwatch-agent-ecr-repository-key"
  target_key_id = aws_kms_key.cloudwatch_agent_ecr_repository_key.key_id
}
