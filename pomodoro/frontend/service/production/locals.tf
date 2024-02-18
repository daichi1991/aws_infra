locals {
  repository_url = "https://github.com/daichi1991/pomodoro_playlist_frontend"
}

locals {
  amplify_app_environment_variables = {
    next_public_api_url = {
      name  = "NEXT_PUBLIC_API_URL"
      value = "https://api.pomo-sync-sounds.com"
      type  = "PLAINTEXT"
    }
    custom_image = {
      name  = "_CUSTOM_IMAGE"
      value = "public.ecr.aws/docker/library/node:20.11.0"
      type  = "PLAINTEXT"
    }
  }
}