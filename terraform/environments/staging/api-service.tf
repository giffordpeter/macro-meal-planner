module "api_service" {
  source = "../../modules/ecs-service"

  project_name    = var.project_name
  environment     = var.environment
  service_name    = "api"
  
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  cluster_id          = module.ecs.cluster_id
  cluster_name        = module.ecs.cluster_name
  load_balancer_arn   = module.ecs.load_balancer_arn
  
  service_security_group_id     = module.ecs.task_security_group_id
  service_discovery_namespace_id = module.ecs.service_discovery_namespace_id
  task_execution_role_arn       = module.ecs.task_execution_role_arn
  task_role_arn                 = module.ecs.task_role_arn
  log_group_name               = module.ecs.log_group_name

  container_image = "${var.ecr_repository_url}:latest"
  container_port  = 8000
  health_check_path = "/api/health"
  
  desired_count = 2
  task_cpu      = 256
  task_memory   = 512
  min_capacity  = 1
  max_capacity  = 4

  environment_variables = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    },
    {
      name  = "PORT"
      value = "8000"
    }
  ]

  secrets = [
    {
      name      = "DATABASE_URL"
      valueFrom = var.database_url_secret_arn
    }
  ]

  create_https_listener = false  # For staging, we'll start with HTTP only
  create_http_listener  = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}
