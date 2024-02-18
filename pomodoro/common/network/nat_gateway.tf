resource "aws_nat_gateway" "prod_pomodoro_backend_natgw" {
  allocation_id = aws_eip.prod_pomodoro_backend_eip.id
  subnet_id     = aws_subnet.prod_pomodoro_backend["public-1a"].id

  tags = {
    Name = "prod-pomodoro-backend-natgw"
  }
}