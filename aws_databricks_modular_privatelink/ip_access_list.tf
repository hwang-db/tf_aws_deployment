provider "databricks" {
  alias = "created_workspace"
  host  = "https://dbc-fc3b108a-8866.cloud.databricks.com"
  token = "yourtoken"
}

resource "databricks_workspace_conf" "this" {
  provider = databricks.created_workspace
  custom_config = {
    "enableIpAccessLists" = true
  }
}

resource "databricks_ip_access_list" "block-list" {
  provider     = databricks.created_workspace
  label        = "block-list"
  list_type    = "BLOCK"
  ip_addresses = ["111.65.45.14"]
}

resource "databricks_ip_access_list" "allow-list" {
  provider     = databricks.created_workspace
  label        = "allow-list"
  list_type    = "ALLOW"
  ip_addresses = ["119.74.128.46"]
}
