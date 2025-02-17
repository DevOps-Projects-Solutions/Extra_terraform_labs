output "source_bucket_name" {
  description = "The name of the source S3 bucket."
  value       = module.s3_source.bucket_name
}

output "replica_bucket_name" {
  description = "The name of the replica S3 bucket."
  value       = module.s3_replica.bucket_name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = module.dynamodb.table_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function."
  value       = module.lambda.lambda_function_arn
}