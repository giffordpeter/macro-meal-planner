variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., staging, production)"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "rds_cluster_id" {
  description = "ID of the RDS cluster"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization alarm"
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Threshold for memory utilization alarm"
  type        = number
  default     = 80
}

variable "error_threshold" {
  description = "Threshold for 5XX error count"
  type        = number
  default     = 10
}

variable "latency_threshold" {
  description = "Threshold for API latency (seconds)"
  type        = number
  default     = 2
}

variable "log_error_threshold" {
  description = "Threshold for error log count"
  type        = number
  default     = 10
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarms trigger"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
