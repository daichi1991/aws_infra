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
