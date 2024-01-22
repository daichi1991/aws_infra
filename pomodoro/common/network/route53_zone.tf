resource "aws_route53_zone" "pomodoro" {
  name = "pomo-sync-sounds.com"
}

################################
# ACM
################################
resource "aws_acm_certificate" "pomodoro" {
  domain_name               = aws_route53_zone.pomodoro.name
  subject_alternative_names = ["*.${aws_route53_zone.pomodoro.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "pomodoro_dns_verify" {
  for_each = {
    for dvo in aws_acm_certificate.pomodoro.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.pomodoro.id
}

resource "aws_acm_certificate_validation" "pomodoro" {
  certificate_arn         = aws_acm_certificate.pomodoro.arn
  validation_record_fqdns = [for record in aws_route53_record.pomodoro_dns_verify : record.fqdn]
}
