# API Gateway
resource "aws_api_gateway_rest_api" "lambda_api" {
  name = "lambda_api"
}

resource "aws_api_gateway_resource" "resource" {
  path_part = "dynamodbmanager"
  parent_id = "${aws_api_gateway_rest_api.lambda_api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.lambda_api.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.lambda_api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.lambda_api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${aws_api_gateway_rest_api.lambda_api.id}"
  stage_name  = "${var.api_stage_name}"
}

# Lambda
resource "aws_lambda_permission" "api_gtw_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.lambda_api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_lambda_function" "lambda" {
  filename         = "lambda.zip"
  function_name    = "${var.lambda_name}"
  role             = "${data.aws_iam_role.lab_iam_role.arn}"
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
}

# CloudWatch 
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 30
}

#DynamoDB
resource "aws_dynamodb_table" "anything" {
  name           = "anything"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}