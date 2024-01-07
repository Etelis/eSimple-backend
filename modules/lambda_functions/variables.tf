# Terraform file for the lambda_functions module

variable "lambda_functions" {
  description = "A map of Lambda function names"
  type        = map(string)
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  default     = "python3.12"
}

variable "handler" {
  description = "The handler method for the Lambda function"
  default     = "lambda_handler"
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for Lambda functions"
  type        = string
}

variable "timeout" {
  description = "The execution timeout for the Lambda function"
  default     = 180 # 3 minutes in seconds
}
