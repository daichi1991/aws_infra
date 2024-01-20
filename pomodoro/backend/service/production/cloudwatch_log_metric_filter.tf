resource "aws_cloudwatch_log_metric_filter" "prod_pomodoro_backend_container_cpu_utilization" {
  log_group_name = "/aws/ecs/containerinsights/prod-pomodoro-backend/performance"
  name           = "prod-pomodoro-backend-container-cpu-utilization"
  pattern        = "{$.ContainerName=\"*\" && $.CpuUtilized=\"*\"}"

  metric_transformation {
    dimensions = {
      "ContainerName" = "$.ContainerName"
    }
    name      = "CPUUtilization"
    namespace = "prod-pomodoro-backend"
    unit      = "Count"
    value     = "$.CpuUtilized"
  }
}

resource "aws_cloudwatch_log_metric_filter" "prod_pomodoro_backend_container_memory_utilization" {
  log_group_name = "/aws/ecs/containerinsights/prod-pomodoro-backend/performance"
  name           = "prod-pomodoro-backend-container-memory-utilization"
  pattern        = "{$.ContainerName=\"*\" && $.MemoryUtilized=\"*\"}"

  metric_transformation {
    dimensions = {
      "ContainerName" = "$.ContainerName"
    }
    name      = "MemoryUtilization"
    namespace = "prod-pomodoro-backend"
    unit      = "Megabytes"
    value     = "$.MemoryUtilized"
  }
}
