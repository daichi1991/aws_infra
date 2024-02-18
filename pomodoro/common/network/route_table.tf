//prod
resource "aws_route_table" "prod_pomodoro_backend_public" {
  for_each = local.prod_pomodoro_backend_public_routetables

  vpc_id = aws_vpc.pomodoro.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pomodoro_backend.id
  }

  tags = {
    Name        = each.value.name
    Environment = "production"
  }
}

resource "aws_route_table" "prod_pomodoro_backend_private" {
  for_each = local.prod_pomodoro_backend_private_routetables

  vpc_id = aws_vpc.pomodoro.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.prod_pomodoro_backend_natgw.id
  }

  tags = {
    Name        = each.value.name
    Environment = "production"
  }
}
