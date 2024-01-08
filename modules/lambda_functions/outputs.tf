output "lambda_function_arns" {
  value = { for name, lambda in aws_lambda_function.lambda_function : name => lambda.arn }
  description = "Map of Lambda function names to their ARNs"
}
