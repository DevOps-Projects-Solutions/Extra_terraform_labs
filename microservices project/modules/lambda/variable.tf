variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function."
  type        = string
}

variable "source_bucket_name" {
  description = "The name of the source S3 bucket."
  type        = string
}


variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}
variable "source_bucket_arn" {
    description = "The ARN of the S3 bucket."
    type        = string
}

variable "path_code" {
    description = "the path of the lambda code"
    type        = string
}
variable "handler" {
    description = "the path of the lambda code"
    type        = string
}