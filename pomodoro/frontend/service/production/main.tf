provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      "Service"       = "pomodoro-frontend"
      "Description"   = "Managed by Terraform"
      "CreatedByRole" = "admin"
    }
  }
}

terraform {
  required_version = ">= 1.7.0"

  backend "s3" {
    bucket = "terraform-2024"
    key    = "pomodoro-frontend/service/production/terraform.tfstate"
    region = "ap-northeast-1"
  }
}