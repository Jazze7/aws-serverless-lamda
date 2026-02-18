variable "region" {  
    description = "The region to deploy the infrastructure to"
    type= string
    default = "ap-south-1"
}

variable "project_name" {
    description = "The name of the project"
    type= string
    default = "aws-lambda-terraform"
}