# Terraform backend configuration for storing the state file in an S3 bucket and using DynamoDB for state locking, specifically for the prod environment and the app component.

terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "prod/app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
