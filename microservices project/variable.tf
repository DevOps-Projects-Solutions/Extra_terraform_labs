variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "source_bucket_name" {
  description = "The name of the source S3 bucket where files are initially uploaded."
  type        = string
}


variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to store file metadata."
  type        = string
}

variable "lambda1_function_name" {
  description = "The name of the Lambda function that handles file replication."
  type        = string
}
variable "lambda2_function_name" {
  description = "The name of the Lambda function that handles file replication."
  type        = string
}
variable "path_code_1" {
  description = "the path of the lambda code"
  type        = string
}

variable "path_code_2" {
  description = "the path of the lambda code"
  type        = string
}