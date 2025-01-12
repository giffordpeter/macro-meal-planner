module "api_ecr" {
  source = "../../modules/ecr"

  project_name      = var.project_name
  environment       = var.environment
  repository_name   = "api"
  github_repository = var.github_repository

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
