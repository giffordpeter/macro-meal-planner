output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}

output "reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "cluster_identifier" {
  description = "The cluster identifier"
  value       = aws_rds_cluster.aurora.cluster_identifier
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.aurora.database_name
}

output "security_group_id" {
  description = "The security group ID for the database cluster"
  value       = aws_security_group.aurora.id
}

output "cluster_arn" {
  description = "The ARN of the database cluster"
  value       = aws_rds_cluster.aurora.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_id" {
  description = "The ID of the database instance"
  value       = aws_db_instance.main.id
}

output "db_secret_arn" {
  description = "ARN of the secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db.id
}

output "monitoring_role_arn" {
  description = "ARN of the RDS monitoring role"
  value       = aws_iam_role.rds_monitoring.arn
}
