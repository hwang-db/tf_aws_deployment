terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      #configuration_aliases = [databricks.ws1, databricks.ws2]
    }
  }
}

resource "databricks_workspace_conf" "this" {
  custom_config = {
    "enableIpAccessLists" = true
  }
}

data "http" "my" {
  url = "https://ifconfig.me"
}

resource "databricks_ip_access_list" "current_machine_ip" {
  label        = "${data.http.my.body} is allowed to access workspace"
  list_type    = "ALLOW"
  ip_addresses = ["${data.http.my.body}/32"]
  depends_on   = [databricks_workspace_conf.this]
}


resource "databricks_ip_access_list" "allow-list" {
  label        = "allow-list for testing"
  list_type    = "ALLOW"
  ip_addresses = var.allow_list
  depends_on   = [databricks_workspace_conf.this]
}

resource "databricks_ip_access_list" "block-list" {
  label        = "block-list for testing"
  list_type    = "BLOCK"
  ip_addresses = var.block_list
  depends_on   = [databricks_workspace_conf.this]
}
