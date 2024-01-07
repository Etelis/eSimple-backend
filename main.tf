# Provider Configuration
provider "aws" {
  region = "eu-central-1" # Example region
}

# Module for API Gateway
module "api_gateway" {
  source = "./modules/api_gateway"
  # Pass any required variables to the module
}

# Module for Lambda Functions
module "lambda_functions" {
  source = "./modules/lambda_functions"
  # Pass any required variables to the module
}

# Module for DynamoDB
module "dynamodb" {
  source = "./modules/dynamodb"
  # Pass any required variables to the module
}

# Module for Cognito
module "cognito" {
  source = "./modules/cognito"
  # Pass any required variables to the module
}