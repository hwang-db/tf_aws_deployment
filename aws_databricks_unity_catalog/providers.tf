terraform {
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
  region = var.region
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id   // like a shared account? HA from multiple email accounts
  username   = var.databricks_account_username
  password   = var.databricks_account_password
  auth_type  = "basic"
}

provider "databricks" {
  alias = "ws1"
  host  = "https://dbc-a1d8d35b-9204.cloud.databricks.com"
  token = var.pat_ws_1
}

provider "databricks" {
  alias = "ws2"
  host  = "https://dbc-5779d7bc-08cb.cloud.databricks.com"
  token = var.pat_ws_2
}
