terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  alias = "ws1"
  host  = "https://dbc-7805b76d-f7d1.cloud.databricks.com"
  token = var.pat_ws_1
}

provider "databricks" {
  alias = "ws2"
  host  = "https://dbc-4544745c-593b.cloud.databricks.com"
  token = var.pat_ws_2
}
