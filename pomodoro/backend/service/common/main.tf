provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Service     = "pomodoro-backend"
      Description = "Managed by Terraform"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "osaka"

  default_tags {
    tags = {
      Service       = "pomodoro-backend"
      CreatedByRole = "admin"
      Description   = "Managed by Terraform"
    }
  }
}

terraform {
  required_version = ">= 1.7.0"

  backend "s3" {
    bucket = "terraform-2024"
    key    = "pomodoro-backend/common/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
