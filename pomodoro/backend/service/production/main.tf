provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      "Service"       = "pomodoro-backend"
      "Description"   = "Managed by Terraform"
      "CreatedByRole" = "admin"
    }
  }
}

provider "aws" {
  alias  = "osaka"
  region = "ap-northeast-3"

  default_tags {
    tags = {
      "Service"       = "pomodoro-backend"
      "Description"   = "Managed by Terraform"
      "CreatedByRole" = "admin"
    }
  }
}

terraform {
  required_version = ">= 1.7.0"

  backend "s3" {
    bucket = "terraform-2024"
    key    = "pomodoro-backend/service/production/terraform.tfstate"
    region = "ap-northeast-1"
  }
}