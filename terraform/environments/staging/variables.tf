variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "database_password" {
  description = "Master password for the Aurora database"
  type        = string
  sensitive   = true
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository for the API service"
  type        = string
}

variable "database_url_secret_arn" {
  description = "ARN of the secret containing the database URL"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "macro-meal-planner"
}

variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

# Application Secrets
variable "jwt_secret" {
  description = "Secret for JWT token signing"
  type        = string
  sensitive   = true
}

variable "cookie_secret" {
  description = "Secret for cookie signing"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key for external services"
  type        = string
  sensitive   = true
}

variable "redis_url" {
  description = "Redis connection URL"
  type        = string
  sensitive   = true
  default     = ""  # Optional for staging
}
