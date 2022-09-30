terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  alias = "ws1"
  host  = "https://dbc-0162ae20-2722.cloud.databricks.com"
  token = var.pat_ws_1
}

provider "databricks" {
  alias = "ws2"
  host  = "https://dbc-db10833c-d6ef.cloud.databricks.com"
  token = var.pat_ws_2
}
