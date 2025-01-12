locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# KMS Key for Secrets Encryption
resource "aws_kms_key" "secrets" {
  description             = "KMS key for ${local.name_prefix} secrets"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-secrets-key"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/${local.name_prefix}-secrets"
  target_key_id = aws_kms_key.secrets.key_id
}

# Database Credentials Secret
resource "aws_secretsmanager_secret" "database" {
  name        = "${local.name_prefix}/database"
  description = "Database credentials for ${local.name_prefix}"
  kms_key_id  = aws_kms_key.secrets.arn

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-database"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username = var.database_username
    password = var.database_password
    host     = var.database_host
    port     = var.database_port
    dbname   = var.database_name
    url      = "postgresql://${var.database_username}:${var.database_password}@${var.database_host}:${var.database_port}/${var.database_name}"
  })
}

# Application Secrets
resource "aws_secretsmanager_secret" "application" {
  name        = "${local.name_prefix}/application"
  description = "Application secrets for ${local.name_prefix}"
  kms_key_id  = aws_kms_key.secrets.arn

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-application"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}

resource "aws_secretsmanager_secret_version" "application" {
  secret_id = aws_secretsmanager_secret.application.id
  secret_string = jsonencode(merge(
    var.application_secrets,
    {
      ENVIRONMENT = var.environment
    }
  ))
}

# IAM Policy for ECS Tasks
data "aws_iam_policy_document" "secrets_access" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      aws_secretsmanager_secret.database.arn,
      aws_secretsmanager_secret.application.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.secrets.arn
    ]
  }
}

resource "aws_iam_policy" "secrets_access" {
  name        = "${local.name_prefix}-secrets-access"
  description = "Policy for accessing ${local.name_prefix} secrets"
  policy      = data.aws_iam_policy_document.secrets_access.json

  tags = merge(var.tags, {
    Name        = "${local.name_prefix}-secrets-access"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  })
}
