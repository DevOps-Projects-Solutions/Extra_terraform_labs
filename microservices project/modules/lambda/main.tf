resource "aws_lambda_function" "replication_lambda" {
  function_name = var.lambda_function_name
  handler       = "lambda_function_${var.handler}.lambda_handler"
  runtime       = "python3.9"
  role          = var.lambda_role_arn

  filename         = "${path.module}/${var.path_code}"
  source_code_hash = filebase64sha256("${path.module}/${var.path_code}")

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
      BUCKET_NAME = var.source_bucket_name
    }
  }
}
# Allow S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.replication_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_bucket_arn
}

