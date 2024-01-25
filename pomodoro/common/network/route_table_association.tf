resource "aws_route_table_association" "prod_pomodoro_backend_public" {
  for_each       = toset(["public-1a", "public-1c"])
  subnet_id      = aws_subnet.prod_pomodoro_backend[each.key].id
  route_table_id = aws_route_table.prod_pomodoro_backend_public[each.key].id
}

resource "aws_route_table_association" "prod_pomodoro_backend_private" {
  for_each       = toset(["private-1a", "private-1c"])
  subnet_id      = aws_subnet.prod_pomodoro_backend[each.key].id
  route_table_id = aws_route_table.prod_pomodoro_backend_private[each.key].id
}