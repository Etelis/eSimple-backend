output "lambda_function_arns" {
  value = {for k, v in aws_lambda_function.lambda : k => v.arn}
  description = "The ARNs of the deployed Lambda functions"
}