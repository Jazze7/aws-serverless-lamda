resource "aws_dynamodb_table" "aws_dynamodb_table_lambda" {
    name= "${var.project_name}-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"

    attribute {
      name= "id"
      type = "S"
    }

    ttl {
      attribute_name = "ttl"
      enabled = true
    }
  
}