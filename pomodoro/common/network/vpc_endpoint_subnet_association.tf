resource "aws_vpc_endpoint_subnet_association" "pomodoro_ecr_api" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_ecr["pomodoro-ecr-api"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_ecr_dkr" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_ecr["pomodoro-ecr-dkr"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_secretsmanager" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_secretsmanager["pomodoro-secretsmanager"].id
  subnet_id       = each.value
}

resource "aws_vpc_endpoint_subnet_association" "pomodoro_logs" {
  for_each = local.target_subnet

  vpc_endpoint_id = aws_vpc_endpoint.pomodoro_logs["pomodoro-logs"].id
  subnet_id       = each.value
}

# resource "aws_vpc_endpoint_subnet_association" "pomodoro_xray" {
#   for_each = local.target_subnet

#   vpc_endpoint_id = aws_vpc_endpoint.pomodoro_xray["pomodoro-xray"].id
#   subnet_id       = each.value
# }
