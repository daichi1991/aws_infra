resource "aws_amplify_app" "pomodoro_frontend" {
  name       = "pomodoro-frontend"
  repository = local.repository_url
  access_token = var.github_access_token

  build_spec = <<EOF
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOF

  enable_auto_branch_creation = true
  enable_branch_auto_build = true
  enable_branch_auto_deletion = true
  platform = "WEB_COMPUTE"

  iam_service_role_arn = aws_iam_role.pomodoro_frontend.arn

  auto_branch_creation_config {
    enable_pull_request_preview = true
  }

  environment_variables = {
    # APIのURLを設定
    NEXT_PUBLIC_API_URL = local.amplify_app_environment_variables.next_public_api_url
    # カスタムイメージを設定
    _CUSTOM_IMAGE = local.amplify_app_environment_variables.custom_image
  }

  tags = {
    Name = "pomodoro-frontend"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.pomodoro_frontend.id
  branch_name = "main"
  framework = "Next.js - SSR"

  enable_auto_build = true

  stage     = "PRODUCTION"
}

# ドメインを設定
resource "aws_amplify_domain_association" "pomodoro_frontend" {
  app_id      = aws_amplify_app.pomodoro_frontend.id
  domain_name = local.domain_name

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
}
