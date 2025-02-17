# API Gateway Module
module "api_gateway" {
  source                = "./modules/API"
  api_name              = "file-upload-api"
  lambda_arn            = module.lambda1.lambda_function_arn
  lambda1_function_name = var.lambda1_function_name
  stage_name            = "dev"
}
module "lambda1" {
  source               = "./modules/lambda"
  source_bucket_name   = module.s3_source.bucket_name
  dynamodb_table_name  = module.dynamodb.table_name
  lambda_function_name = var.lambda1_function_name
  lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
  source_bucket_arn    = module.s3_source.bucket_arn
  path_code            = var.path_code_1
  handler = "1"
}

module "lambda2" {
  source               = "./modules/lambda"
  source_bucket_name   = module.s3_source.bucket_name
  dynamodb_table_name  = module.dynamodb.table_name
  lambda_function_name = var.lambda2_function_name
  lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
  source_bucket_arn    = module.s3_source.bucket_arn
  path_code            = var.path_code_2
  handler = "2"
}

module "s3_source" {
  source                 = "./modules/s3"
  bucket_name            = var.source_bucket_name
  lambda_function_arn    = module.lambda2.lambda_function_arn
  create_s3_notification = true
}


module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}




resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy" "lambda_s3_dynamodb_policy" {
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${module.s3_source.bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = module.dynamodb.table_arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}