terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-serverless-jassim"
    key = "lambda-app/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
    
  }
}