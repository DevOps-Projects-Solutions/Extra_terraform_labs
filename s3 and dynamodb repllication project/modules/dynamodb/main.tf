resource "aws_dynamodb_table" "metadata_table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "FileID"

  attribute {
    name = "FileID"
    type = "S"
  }
}