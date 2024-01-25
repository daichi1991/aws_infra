resource "aws_vpc_endpoint_subnet_association" "pomodoro_backend_ecr_api" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_ecr["pomodoro-backend-ecr-api"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_backend_ecr_dkr" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_ecr["pomodoro-backend-ecr-dkr"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_backend_secretsmanager" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_backend_secretsmanager["pomodoro-backend-secretsmanager"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_backend_logs" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_backend_logs["pomodoro-backend-logs"].id
  subnet_id       = each.value
}

# resource "aws_vpc_endpoint_subnet_association" "pomodoro_xray" {
#   for_each = local.target_subnet

#   vpc_endpoint_id = aws_vpc_endpoint.pomodoro_xray["pomodoro-xray"].id
#   subnet_id       = each.value
# }
