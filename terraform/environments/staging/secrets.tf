module "secrets" {
  source = "../../modules/secrets"

  project_name = var.project_name
  environment  = var.environment

  database_username = module.database.cluster_master_username
  database_password = var.database_password
  database_host     = module.database.cluster_endpoint
  database_port     = 5432
  database_name     = module.database.database_name

  application_secrets = {
    JWT_SECRET            = var.jwt_secret
    COOKIE_SECRET        = var.cookie_secret
    API_KEY              = var.api_key
    REDIS_URL            = var.redis_url
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# Attach secrets access policy to ECS task role
resource "aws_iam_role_policy_attachment" "ecs_task_secrets" {
  role       = module.ecs.task_role_name
  policy_arn = module.secrets.secrets_access_policy_arn
}
