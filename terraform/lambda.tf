resource "aws_iam_role" "lambda_role" {
    name = "${var.project_name}-lambda-role"

    assume_role_policy = jsonencode({
            Version = "2012-10-17"
            Statement= [{
                Effect = "Allow"
                Sid=""
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
               Action = "sts:AssumeRole"
            }]
    })
  
}
resource "aws_iam_role_policy_attachment" "lamda-role-policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}
resource "aws_iam_role_policy_attachment" "db-role-policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "archive_file" "node_app" {
    type = "zip"
    source_dir ="../lambda"
    output_path = "lambda.zip"
}
resource "aws_lambda_function" "node_function" {
    function_name = "${var.project_name}-function"
    role = aws_iam_role.lambda_role.arn
    publish = true

    filename = data.archive_file.node_app.output_path
    source_code_hash = data.archive_file.node_app.output_base64sha256


    handler = "handler.handler"
    runtime = "nodejs20.x"

    memory_size = 128
    timeout = 5

    environment {
      variables = {
        TABLE= aws_dynamodb_table.aws_dynamodb_table_lambda.name
      }
    }
}