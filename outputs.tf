output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = module.function.function_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = module.function.function_name
}

output "alias_arn" {
  description = "ARN of the Lambda alias"
  value       = module.alias.arn
}

output "function_url" {
  description = "URL of the Lambda function"
  value       = module.function_url.function_url
}

output "event_source_mapping_uuid" {
  description = "UUID of the event source mapping"
  value       = module.event_source_mapping.uuid
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = module.log_group.arn
}
