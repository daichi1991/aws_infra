locals {
  repository_url = "https://github.com/daichi1991/pomodoro_playlist_frontend"
}

locals {
  amplify_app_environment_variables = {
    next_public_api_url = "https://pomo-sync-sounds-api.onrender.com"
    custom_image = "public.ecr.aws/docker/library/node:20.11.0"
  }
}

locals {
  domain_name = "pomo-sync-sounds.com"
}