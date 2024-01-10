variable "lambda_functions" {
  description = "Map of Lambda function names and their specific settings"
  type = map(object({
    handler = string
  }))

  default = {
    "activateSim" = { handler = "activateSim.lambda_handler" },
    "getExpiredeSims" = { handler = "getExpiredeSims.lambda_handler" },
    "getNonExpiredeSim" = { handler = "getNonExpiredeSim.lambda_handler" },
    "getNonExpiredeSims" = { handler = "getNonExpiredeSims.lambda_handler" },
    "updateSimInformation" = { handler = "updateSimInformation.lambda_handler" }
  }
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda functions"
  type        = string
  default     = "arn:aws:iam::994931931881:role/eSims_Lambda_Rule"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda functions"
  type        = string
  default     = "python3.12.1"
}

variable "lambda_timeout" {
  description = "Timeout in seconds for the Lambda functions"
  type        = number
  default     = 180
}

variable "token" {
  description = "Token for Lambda environment variables"
  type        = string
  default     = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjQ4MjYzNzgwODIsImlhdCI6MTcwNDMxNDA4MiwiZGlzY29yZFVzZXIiOiJldGVsaXMyMDE5IiwiZGlzY29yZElEIjo2NzA5NDc2Nzc2NTA4MTI5Mjl9.ZHwtWo110E6C0ryBPZy1ZvUbgFdqLM9eiAqhcD-igYs"
}
