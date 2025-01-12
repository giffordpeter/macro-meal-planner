module "ecs" {
  source = "../../modules/ecs"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id         = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  log_retention_days = 7
  container_insights = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
