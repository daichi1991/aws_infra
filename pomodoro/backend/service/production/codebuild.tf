// Docker images provided by CodeBuild
// https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
resource "aws_codebuild_project" "prod_pomodoro_backend" {
  name               = "prod-pomodoro-backend"
  service_role       = aws_iam_role.prod_pomodoro_backend_codebuild_service_role.arn
  project_visibility = "PRIVATE"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = local.codebuild_environment_variables

      content {
        name  = environment_variable.value.name
        type  = environment_variable.value.type
        value = environment_variable.value.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
    }
    s3_logs {
      status              = "ENABLED"
      encryption_disabled = true
      location            = "${data.aws_s3_bucket.pomodoro_backend.id}/codebuild/production/logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = ".container/buildspec.yml"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  tags = {
    "Name" : "pomodoro-backend-codebuild"
  }
}
