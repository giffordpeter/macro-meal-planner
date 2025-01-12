module "database" {
  source = "../../modules/database"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets
  
  allowed_security_groups = [
    module.ecs.task_security_group_id
  ]

  # Database configuration
  db_name     = "macro_meal_planner"
  db_username = "app_user"
  
  # Instance configuration for staging
  instance_class      = "db.t4g.small"
  allocated_storage   = 20
  backup_retention_days = 7

  # Monitoring configuration
  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = local.tags
}
