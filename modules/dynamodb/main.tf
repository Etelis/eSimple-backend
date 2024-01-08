resource "aws_dynamodb_table" "eSims" {
  name           = "eSims"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "eSimID"
  range_key      = "userID"

  attribute {
    name = "eSimID"
    type = "S"
  }

  attribute {
    name = "userID"
    type = "S"
  }

  # Additional configurations like tags, global secondary indexes, etc., can be added here
}
