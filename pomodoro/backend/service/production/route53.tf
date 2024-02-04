resource "aws_route53_record" "prod_pomodoro_backend" {
  zone_id = data.aws_route53_zone.pomdoro_com_zone.zone_id
  name    = "api.pomo-sync-sounds.com"
  type    = "A"

  alias {
    # NOTE: nameを直書きしているのはaws_lb.my_lb.dns_nameの形式で参照すると先頭の"dualstack"が抜けるため
    #       see: https://github.com/hashicorp/terraform-provider-aws/issues/360
    name                   = "dualstack.${aws_lb.prod_pomodoro_backend_lb.dns_name}"
    zone_id                = aws_lb.prod_pomodoro_backend_lb.zone_id
    evaluate_target_health = true
  }
}
