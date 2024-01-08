resource "aws_api_gateway_rest_api" "api" {
  name        = "eSIMManagementService"
  description = "API to manage eSIM activations, archives, and support queries."
}

# Resources for each API path
resource "aws_api_gateway_resource" "esims_active" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "eSIMs/active"
}

resource "aws_api_gateway_resource" "esims_active_esimid" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.esims_active.id
  path_part   = "{eSIMId}"
}

resource "aws_api_gateway_resource" "esims_archived" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "eSIMs/archived"
}

resource "aws_api_gateway_resource" "esims_providers" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "eSIMs/providers"
}

resource "aws_api_gateway_resource" "help_queries" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "help/queries"
}

# ... (Continue with resources for other paths)

# Methods, Method Responses, and Lambda Integrations for each API path
# Example for /eSIMs/active GET
resource "aws_api_gateway_method" "esims_active_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.esims_active.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  # ...
}

resource "aws_api_gateway_method_response" "esims_active_get_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.esims_active.id
  http_method = aws_api_gateway_method.esims_active_get.http_method
  status_code = "200"
  # ...
}

resource "aws_api_gateway_integration" "esims_active_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.esims_active.id
  http_method             = aws_api_gateway_method.esims_active_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda_function["getNonExpiredeSims"].invoke_arn
}

resource "aws_api_gateway_integration_response" "esims_active_get_lambda_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.esims_active.id
  http_method = aws_api_gateway_integration.esims_active_get_lambda.http_method
  status_code = aws_api_gateway_method_response.esims_active_get_200.status_code
  # ...
}

# ... (Continue with methods, method responses, and integrations for other paths and methods)

# Authorizer for Cognito
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "CognitoAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_user_pool_arn]
}
