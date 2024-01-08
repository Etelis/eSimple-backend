output "api_gateway_id" {
  value       = aws_api_gateway_rest_api.api.id
  description = "The ID of the API Gateway"
}

output "api_gateway_execution_arn" {
  value       = aws_api_gateway_rest_api.api.execution_arn
  description = "The execution ARN of the API Gateway"
}

output "api_gateway_invoke_url" {
  value       = aws_api_gateway_deployment.deployment.invoke_url
  description = "Invoke URL of the deployed API Gateway"
}
