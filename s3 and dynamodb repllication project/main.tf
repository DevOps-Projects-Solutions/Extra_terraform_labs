module "s3_source" {
  source = "./modules/s3"
  bucket_name = var.source_bucket_name
  lambda_function_arn = module.lambda.lambda_function_arn
  create_s3_notification = true 
}

module "s3_replica" {
  source = "./modules/s3"
  bucket_name = var.replica_bucket_name
  lambda_function_arn = module.lambda.lambda_function_arn
  create_s3_notification = false
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
}

module "lambda" {
  source = "./modules/lambda"

  source_bucket_name = module.s3_source.bucket_name
  replica_bucket_name = module.s3_replica.bucket_name
  dynamodb_table_name = module.dynamodb.table_name

  lambda_function_name = var.lambda_function_name
  lambda_role_arn      = aws_iam_role.lambda_exec_role.arn
  source_bucket_arn = module.s3_source.bucket_arn
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
          "${module.s3_source.bucket_arn}/*",
          "${module.s3_replica.bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = module.dynamodb.table_arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}