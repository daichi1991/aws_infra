resource "aws_vpc_endpoint" "pomodoro_ecr" {
  for_each = local.pomodoro_ecr_service_names

  vpc_id            = aws_vpc.pomodoro.id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.pomodoro_ecr.id
  ]

  private_dns_enabled = true

  tags = {
    Name = each.key
  }
}

resource "aws_vpc_endpoint" "pomodoro_backend_secretsmanager" {
  for_each = local.pomodoro_backend_secretsmanager_service_names

  vpc_id            = aws_vpc.pomodoro.id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.pomodoro_secretsmanager.id
  ]

  private_dns_enabled = true

  tags = {
    Name = each.key
  }
}

resource "aws_vpc_endpoint" "pomodoro_backend_logs" {
  for_each = local.pomodoro_backend_logs_service_names

  vpc_id            = aws_vpc.pomodoro.id
  service_name      = each.value.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.pomodoro_logs.id
  ]

  private_dns_enabled = true

  tags = {
    Name = each.key
  }
}

# resource "aws_vpc_endpoint" "pomodoro_xray" {
#   for_each = local.pomodoro_xray_service_names

#   vpc_id            = aws_vpc.pomodoro.id
#   service_name      = each.value.service_name
#   vpc_endpoint_type = "Interface"

#   security_group_ids = [
#     aws_security_group.pomodoro_xray.id
#   ]

#   private_dns_enabled = true

#   tags = {
#     Name = each.key
#   }
# }

resource "aws_vpc_endpoint" "pomodoro_s3" {
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_id            = aws_vpc.pomodoro.id

  route_table_ids = [
    aws_route_table.prod_pomodoro_private["private-1a"].id,
    aws_route_table.prod_pomodoro_private["private-1c"].id
  ]
  tags = {
    Name = "pomodoro-s3"
  }
}