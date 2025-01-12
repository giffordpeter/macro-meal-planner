resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-${var.environment}-artifacts"
  
  tags = local.tags
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

module "pipeline" {
  source = "../../modules/codebuild"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  artifacts_bucket   = aws_s3_bucket.artifacts.id
  db_secret_arn      = module.database.db_secret_arn
  
  repository_name    = "macro-meal-planner"  # Your CodeCommit repo name
  branch_name        = "main"
  
  ecs_cluster_name   = module.ecs.cluster_name
  ecs_service_name   = module.ecs.service_name

  tags = local.tags
}
