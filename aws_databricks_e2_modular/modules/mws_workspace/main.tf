resource "databricks_mws_workspaces" "this" {
  account_id     = var.databricks_account_id
  aws_region     = var.region
  workspace_name = var.workspace_name
  # deployment_name = local.prefix

  credentials_id           = var.credentials_id
  storage_configuration_id = var.storage_configuration_id
  network_id               = var.network_id
}
