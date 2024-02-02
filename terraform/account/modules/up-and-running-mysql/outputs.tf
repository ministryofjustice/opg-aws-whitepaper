/*output "address" {
  value       = aws_db_instance.sandbox.address
  description = "Database endpoint"
}

output "port" {
  value       = aws_db_instance.sandbox.port
  description = "The database listening port"
}*/

output "all_users" {
  description = "All usernames"
  value       = aws_iam_user.sandbox-user
}

output "all_arns" {
  value = values(aws_iam_user.sandbox-user)[*].arn
}

output "upper_names" {
  value = [for name in var.user_names : upper(name) if length(name) > 5]
}
