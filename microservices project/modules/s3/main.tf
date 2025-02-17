resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}
resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.create_s3_notification ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}