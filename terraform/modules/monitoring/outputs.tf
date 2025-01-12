output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_arn
}

output "alarm_arns" {
  description = "Map of alarm ARNs"
  value = {
    service_cpu  = aws_cloudwatch_metric_alarm.service_cpu.arn
    service_memory = aws_cloudwatch_metric_alarm.service_memory.arn
    alb_5xx      = aws_cloudwatch_metric_alarm.alb_5xx.arn
    api_latency  = aws_cloudwatch_metric_alarm.api_latency.arn
    error_logs   = aws_cloudwatch_metric_alarm.error_logs.arn
  }
}
