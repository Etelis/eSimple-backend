resource "aws_lambda_function" "lambda_function" {
  for_each = var.lambda_functions

  function_name = each.key
  role          = var.lambda_role_arn
  runtime       = var.lambda_runtime
  handler       = each.value.handler
  timeout       = var.lambda_timeout

  environment {
    variables = {
      DYNAMO_TABLE = "eSims"
      TOKEN        = var.token
    }
  }
}
