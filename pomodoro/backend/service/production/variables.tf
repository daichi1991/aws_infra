// SG
variable "ingress_elb_ports" {
  type        = list(any)
  description = "ingress_elb_ports"
  default     = [80, 443]
}

// kinesis-firehose
variable "prod_pomodoro_backend_delivery_streams" {
  type = map(any)

  default = {
    proxy-messages = {
      name   = "prod_pomodoro_backend_proxy_messages"
      prefix = "production/proxy-log/"
    }
    web-messages = {
      name   = "prod_pomodoro_backend_web_messages"
      prefix = "production/web-log/"
    }
  }
}
