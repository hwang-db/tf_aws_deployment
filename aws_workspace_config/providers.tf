terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  alias = "ws1"
  host  = "https://dbc-2c1ea93d-8b8a.cloud.databricks.com"
  token = var.workspace_1_token
}

provider "databricks" {
  alias = "ws2"
  host  = "https://dbc-9cc5f025-7142.cloud.databricks.com"
  token = var.workspace_2_token
}
