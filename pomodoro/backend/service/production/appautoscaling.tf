resource "aws_appautoscaling_target" "prod_pomodoro_backend_scaling_target" {
  min_capacity       = 1
  max_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.prod_pomodoro_backend.name}/${aws_ecs_service.prod_pomodoro_backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# resource "aws_appautoscaling_policy" "prod_pomodoro_backend_scaling_policy" {
#   name               = "prod-pomodoro-backend-scale-policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${aws_ecs_cluster.prod_pomodoro_backend.name}/${aws_ecs_service.prod_pomodoro_backend.name}"
#   scalable_dimension = aws_appautoscaling_target.prod_pomodoro_backend_scaling_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.prod_pomodoro_backend_scaling_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value       = 90
#     disable_scale_in   = false
#     scale_out_cooldown = 0
#     scale_in_cooldown  = 300
#   }
# }
