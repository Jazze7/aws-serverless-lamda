provider "aws"{
    region = "ap-south-1"

}

resource "aws_s3_bucket" "terraform-state-bucket" {
    bucket= "terraform-state-bucket-serverless-jassim"
}



resource "aws_s3_bucket_versioning" "terraform-state-bucket-serverless-versioning" {
    bucket = aws_s3_bucket.terraform-state-bucket.id

    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_dynamodb_table" "lock" {
    name= "terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "lockid"
  
  attribute {
    name="lockid"
    type = "S"
  }
}
