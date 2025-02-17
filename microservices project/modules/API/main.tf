data "aws_caller_identity" "current" {}
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API Gateway for file uploads"
}

resource "aws_api_gateway_resource" "files" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "files"
}

resource "aws_api_gateway_method" "files" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.files.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.files.id
  http_method             = aws_api_gateway_method.files.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
   uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda1_function_name}/invocations"
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
   depends_on = [
    aws_api_gateway_resource.files,
    aws_api_gateway_method.files,
    aws_api_gateway_integration.lambda
  ]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda1_function_name
  principal     = "apigateway.amazonaws.com"

  # Ensure it applies only to this API Gateway
 source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.files.http_method}/${aws_api_gateway_resource.files.path_part}"

}

resource "aws_iam_role" "apigateway_lambda_role" {
  name = "apigateway-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach the IAM policy to the role for Lambda invocation
resource "aws_iam_role_policy" "apigateway_lambda_policy" {
  name = "apigateway-lambda-policy"
  role = aws_iam_role.apigateway_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = var.lambda_arn
      }
    ]
  })
}
