resource "aws_amplify_app" "pomodoro_frontend" {
  name       = "pomodoro-frontend"
  repository = local.repository_url

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

  dynamic "environment_variables" {
    for_each = local.amplify_app_environment_variables

    content {
      name  = environment_variables.value.name
      value = environment_variables.value.value
      type  = environment_variables.value.type
    }
  }
}