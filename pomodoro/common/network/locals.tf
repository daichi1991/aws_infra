// subnet
locals {
  prod_pomodoro_backend_subnets = {
    public-1a = {
      name                    = "prod-pomodoro-backend-public-1a"
      availability_zone       = "ap-northeast-1a"
      cidr_block              = "10.1.0.0/26"
      map_public_ip_on_launch = "true"
    }
    public-1c = {
      name                    = "prod-pomodoro-backend-public-1c"
      availability_zone       = "ap-northeast-1c"
      cidr_block              = "10.1.0.64/26"
      map_public_ip_on_launch = "true"
    }
    private-1a = {
      name                    = "prod-pomodoro-backend-private-1a"
      availability_zone       = "ap-northeast-1a"
      cidr_block              = "10.1.0.128/26"
      map_public_ip_on_launch = "false"
    }
    private-1c = {
      name                    = "prod-pomodoro-backend-private-1c"
      availability_zone       = "ap-northeast-1c"
      cidr_block              = "10.1.0.192/26"
      map_public_ip_on_launch = "false"
    }
  }
}

// routetable
locals {
  prod_pomodoro_backend_public_routetables = {
    public-1a = {
      name = "prod-pomodoro-backend-public-1a"
    }
    public-1c = {
      name = "prod-pomodoro-backend-public-1c"
    }
  }
  prod_pomodoro_backend_private_routetables = {
    private-1a = {
      name = "prod-pomodoro-backend-private-1a"
    }
    private-1c = {
      name = "prod-pomodoro-backend-private-1c"
    }
  }
}

locals {
  # -----------
  # csr
  # -----------
  pomodoro_ecr_service_names = {
    pomodoro-ecr-dkr = {
      service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
    }
    pomodoro-ecr-api = {
      service_name = "com.amazonaws.ap-northeast-1.ecr.api"
    }
  }
  # -----------
  # ssm kms
  # -----------
  pomodoro_ecr_ssm_kms_service_names = {
    pomodoro-ecr-ssm = {
      service_name = "com.amazonaws.ap-northeast-1.ssmmessages"
    }
    pomodoro-ecr-kms = {
      service_name = "com.amazonaws.ap-northeast-1.kms"
    }
  }
}

locals {
  # -----------
  # secretsmanager
  # -----------
  pomodoro_backend_secretsmanager_service_names = {
    pomodoro-backend-secretsmanager = {
      service_name = "com.amazonaws.ap-northeast-1.secretsmanager"
    }
  }
}

locals {
  # -----------
  # logs
  # -----------
  pomodoro_backend_logs_service_names = {
    pomodoro-backend-logs = {
      service_name = "com.amazonaws.ap-northeast-1.logs"
    }
  }
}

# locals {
#   # -----------
#   # xray
#   # -----------
#   pomodoro_xray_service_names = {
#     pomodoro-xray = {
#       service_name = "com.amazonaws.ap-northeast-1.xray"
#     }
#   }
# }

locals {
  target_subnet = {
    prod_1a = aws_subnet.prod_pomodoro_backend["private-1a"].id
    prod_1c = aws_subnet.prod_pomodoro_backend["private-1c"].id
  }
}

# // eip
# locals {
#   env_short = ["dev", "qa", "prod"]
# }