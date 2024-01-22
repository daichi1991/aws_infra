provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Service     = "common-settings"
      Description = "Managed by Terraform"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-2024"
    key    = "common-settings/iam/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
