resource "aws_apigatewayv2_api" "api" {
    name = "${var.project_name}-http"
     protocol_type   = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
    api_id = aws_apigatewayv2_api.api.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.node_function.invoke_arn
}
resource "aws_apigatewayv2_route" "route" {
    api_id = aws_apigatewayv2_api.api.id
    route_key = "ANY /{proxy+}"
    target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_apigatewayv2_stage" "stage" {
    api_id = aws_apigatewayv2_api.api.id 
    name="$default"
    auto_deploy = true
}
resource "aws_lambda_permission" "apigw_lambda" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.node_function.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}