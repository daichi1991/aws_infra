provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Service     = "pomodoro"
      Description = "Managed by Terraform"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-2024"
    key    = "pomodoro/network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
