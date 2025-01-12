# SNS Topic for Alarms
resource "aws_sns_topic" "alarms" {
  name = "${var.project_name}-${var.environment}-alarms"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_policy" "alarms" {
  arn = aws_sns_topic.alarms.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.alarms.arn
      }
    ]
  })
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name    = var.project_name
  environment     = var.environment
  
  ecs_cluster_name   = module.ecs.cluster_name
  ecs_service_name   = module.api_service.service_name
  load_balancer_name = module.ecs.load_balancer_name
  rds_cluster_id     = module.database.cluster_identifier
  log_group_name     = module.ecs.log_group_name

  # Staging thresholds - less strict than production
  cpu_threshold       = 85
  memory_threshold    = 85
  error_threshold     = 20
  latency_threshold   = 5
  log_error_threshold = 20

  alarm_actions = [aws_sns_topic.alarms.arn]

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
