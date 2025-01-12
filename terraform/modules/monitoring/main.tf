locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # ECS Service Metrics
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.ecs_service_name, "ClusterName", var.ecs_cluster_name],
            [".", "MemoryUtilization", ".", ".", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "ECS Service CPU and Memory Utilization"
          period  = 300
        }
      },
      # ALB Metrics
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.load_balancer_name],
            [".", "TargetResponseTime", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", "."],
            [".", "HTTPCode_Target_4XX_Count", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "ALB Metrics"
          period  = 300
        }
      },
      # RDS Metrics
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBClusterIdentifier", var.rds_cluster_id],
            [".", "FreeableMemory", ".", "."],
            [".", "DatabaseConnections", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "RDS Metrics"
          period  = 300
        }
      },
      # API Latency Distribution
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.load_balancer_name, {
              stat = "p50"
            }],
            ["...", {
              stat = "p90"
            }],
            ["...", {
              stat = "p99"
            }]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "API Latency Distribution"
          period  = 300
        }
      }
    ]
  })
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "service_cpu" {
  alarm_name          = "${local.name_prefix}-service-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "This metric monitors ECS service CPU utilization"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-service-cpu"
  })
}

resource "aws_cloudwatch_metric_alarm" "service_memory" {
  alarm_name          = "${local.name_prefix}-service-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.memory_threshold
  alarm_description   = "This metric monitors ECS service memory utilization"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-service-memory"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${local.name_prefix}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.error_threshold
  alarm_description   = "This metric monitors ALB 5XX errors"
  alarm_actions       = var.alarm_actions

  dimensions = {
    LoadBalancer = var.load_balancer_name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-alb-5xx"
  })
}

resource "aws_cloudwatch_metric_alarm" "api_latency" {
  alarm_name          = "${local.name_prefix}-api-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  extended_statistic  = "p99"
  threshold           = var.latency_threshold
  alarm_description   = "This metric monitors API p99 latency"
  alarm_actions       = var.alarm_actions

  dimensions = {
    LoadBalancer = var.load_balancer_name
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-api-latency"
  })
}

# Log Metric Filters
resource "aws_cloudwatch_log_metric_filter" "error_logs" {
  name           = "${local.name_prefix}-error-logs"
  pattern        = "[timestamp, level=ERROR, ...]"
  log_group_name = var.log_group_name

  metric_transformation {
    name          = "ErrorCount"
    namespace     = "${local.name_prefix}/Logs"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_logs" {
  alarm_name          = "${local.name_prefix}-error-logs"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ErrorCount"
  namespace           = "${local.name_prefix}/Logs"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.log_error_threshold
  alarm_description   = "This metric monitors error logs"
  alarm_actions       = var.alarm_actions

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-error-logs"
  })
}

data "aws_region" "current" {}
