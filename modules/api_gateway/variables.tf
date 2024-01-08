variable "api_lambda_integration" {
  description = "Map of API Gateway paths to Lambda function ARNs"
  type = map(string)

  default = {
    "/eSIMs/active" = aws_lambda_function.lambda_function["getNonExpiredeSims"].arn
    "/eSIMs/active/{eSIMId}" = aws_lambda_function.lambda_function["getNonExpiredeSim"].arn
    "/eSIMs/active/{eSIMId}" = aws_lambda_function.lambda_function["activateSim"].arn
    "/eSIMs/archived" = aws_lambda_function.lambda_function["getExpiredeSims"].arn
  }
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool for authentication"
  type        = string
}
