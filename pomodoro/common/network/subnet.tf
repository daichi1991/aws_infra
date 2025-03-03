resource "aws_subnet" "prod_pomodoro_backend" {
  for_each = local.prod_pomodoro_backend_subnets

  vpc_id            = aws_vpc.pomodoro.id
  availability_zone = each.value.availability_zone

  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name        = each.value.name
    Environment = "production"
  }
}
