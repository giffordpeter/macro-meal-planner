output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.service.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.service.id
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.service.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.service.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.service.name
}

output "service_discovery_service_arn" {
  description = "ARN of the service discovery service"
  value       = aws_service_discovery_service.service.arn
}

output "service_discovery_service_name" {
  description = "Name of the service discovery service"
  value       = aws_service_discovery_service.service.name
}

output "autoscaling_target_id" {
  description = "ID of the autoscaling target"
  value       = aws_appautoscaling_target.service.id
}
