
# Terraform Backend Configuration for eSimple

terraform {
  backend "remote" {
    organization = "eSimpleApplication"

    workspaces {
      name = "eSimple"
    }
  }
}

# Note: This configuration uses Terraform Cloud for remote state management.
# Make sure to replace 'organization' and 'workspace' names with your actual Terraform Cloud organization and workspace names.
