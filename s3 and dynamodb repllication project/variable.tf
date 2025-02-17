variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "source_bucket_name" {
  description = "The name of the source S3 bucket where files are initially uploaded."
  type        = string
}

variable "replica_bucket_name" {
  description = "The name of the replica S3 bucket where files will be copied."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to store file metadata."
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function that handles file replication."
  type        = string
}
