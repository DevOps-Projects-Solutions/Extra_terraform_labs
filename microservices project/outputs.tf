output "source_bucket_name" {
  description = "The name of the source S3 bucket."
  value       = module.s3_source.bucket_name
}



output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = module.dynamodb.table_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function."
  value       = module.lambda1.lambda_function_arn
}
output "lambda_function_arn2" {
  description = "The ARN of the Lambda function."
  value       = module.lambda2.lambda_function_arn
}
output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}