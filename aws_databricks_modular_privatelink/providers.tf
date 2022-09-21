terraform { // comment out the backend config and init again, to migrate states back to local backend 
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state-unique"
    key    = "global/s3-databricks-project/terraform.tfstate"
    region = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks-hwang"
    encrypt        = true
  }
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  // provider configuration
  region = var.region
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias     = "mws"
  host      = "https://accounts.cloud.databricks.com"
  username  = var.databricks_account_username
  password  = var.databricks_account_password
  auth_type = "basic"
}
