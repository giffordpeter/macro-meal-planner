locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# CodeBuild IAM Role
resource "aws_iam_role" "codebuild" {
  name = "${local.name_prefix}-codebuild"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# CodeBuild Policy
resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "*"
        ]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${var.artifacts_bucket}/*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          var.db_secret_arn
        ]
        Action = [
          "secretsmanager:GetSecretValue"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "*"
        ]
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}

# CodeBuild Project for Database Migrations
resource "aws_codebuild_project" "db_migration" {
  name          = "${local.name_prefix}-db-migration"
  description   = "Database migration for ${var.environment}"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode            = true

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }

    environment_variable {
      name  = "DB_SECRET_ARN"
      value = var.db_secret_arn
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec-db-migration.yml"
  }

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.private_subnet_ids
    security_group_ids = [aws_security_group.codebuild.id]
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${local.name_prefix}-db-migration"
      status     = "ENABLED"
    }
  }

  tags = var.tags
}

# CloudWatch Alarms for CodeBuild
resource "aws_cloudwatch_metric_alarm" "build_failure" {
  alarm_name          = "${local.name_prefix}-db-migration-failure"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FailedBuilds"
  namespace           = "AWS/CodeBuild"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Database migration build failures"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ProjectName = aws_codebuild_project.db_migration.name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "build_duration" {
  alarm_name          = "${local.name_prefix}-db-migration-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/CodeBuild"
  period              = "300"
  statistic           = "Average"
  threshold           = "900"  # 15 minutes
  alarm_description   = "Database migration taking too long"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ProjectName = aws_codebuild_project.db_migration.name
  }

  tags = var.tags
}

# SNS Topic for Migration Notifications
resource "aws_sns_topic" "migration_notifications" {
  name = "${local.name_prefix}-db-migration-notifications"
  tags = var.tags
}

# Lambda function for migration notifications
resource "aws_lambda_function" "migration_notification" {
  filename         = "${path.module}/lambda/notification.zip"
  function_name    = "${local.name_prefix}-db-migration-notification"
  role            = aws_iam_role.lambda_notification.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  timeout         = 30

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.migration_notifications.arn
      PROJECT_NAME   = var.project_name
      ENVIRONMENT   = var.environment
    }
  }

  tags = var.tags
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_notification" {
  name = "${local.name_prefix}-lambda-notification"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda Policy
resource "aws_iam_role_policy" "lambda_notification" {
  name = "${local.name_prefix}-lambda-notification"
  role = aws_iam_role.lambda_notification.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          aws_sns_topic.migration_notifications.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# CloudWatch Event Rule for CodeBuild
resource "aws_cloudwatch_event_rule" "codebuild_status" {
  name        = "${local.name_prefix}-db-migration-status"
  description = "Track CodeBuild database migration status"

  event_pattern = jsonencode({
    source      = ["aws.codebuild"]
    detail-type = ["CodeBuild Build State Change"]
    detail = {
      project-name = [aws_codebuild_project.db_migration.name]
      build-status = ["SUCCEEDED", "FAILED", "STOPPED"]
    }
  })
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.codebuild_status.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.migration_notification.arn
}

# Lambda Permission
resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowCloudWatchEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.migration_notification.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.codebuild_status.arn
}

# Security Group for CodeBuild
resource "aws_security_group" "codebuild" {
  name        = "${local.name_prefix}-codebuild"
  description = "Security group for CodeBuild projects"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-codebuild"
  })
}

# CodePipeline
resource "aws_codepipeline" "main" {
  name     = "${local.name_prefix}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = var.artifacts_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.repository_name
        BranchName     = var.branch_name
      }
    }
  }

  stage {
    name = "DatabaseMigration"

    action {
      name            = "Migration"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.db_migration.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
      }
    }
  }
}

# CodePipeline Role
resource "aws_iam_role" "codepipeline" {
  name = "${local.name_prefix}-codepipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

# CodePipeline Policy
resource "aws_iam_role_policy" "codepipeline" {
  name = "${local.name_prefix}-codepipeline"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.artifacts_bucket}",
          "arn:aws:s3:::${var.artifacts_bucket}/*"
        ]
      }
    ]
  })
}
