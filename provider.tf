terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIA6PJUQPLU27PDBQ6A"
  secret_key = "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"
}
