# Terraform file for the lambda_functions module

# Terraform configuration for Lambda functions

resource "aws_lambda_function" "lambda" {
  for_each = var.lambda_functions

  function_name = each.key
  runtime       = var.runtime
  handler       = var.handler
  filename      = "${path.module}/function_code/${each.key}.zip"
  role          = var.lambda_role_arn
  timeout       = var.timeout
}
