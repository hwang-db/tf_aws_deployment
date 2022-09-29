variable "databricks_workspace_ids" {
  description = <<EOT
  List of Databricks workspace IDs to be enabled with Unity Catalog.
  Enter with square brackets and double quotes
  e.g. ["111111111", "222222222"]
  EOT
  type        = list(string)
  default     = ["1528552498684811", "2448300997764810"]
}

variable "databricks_users" {
  description = <<EOT
  List of Databricks users to be added at account-level for Unity Catalog. should we put the account owner email here? maybe not since it's always there and we dont want tf to destroy
  Enter with square brackets and double quotes
  e.g ["first.last@domain.com", "second.last@domain.com"]
  EOT
  type        = list(string)
  default     = ["hao.wang@databricks.com", "prashant.singh@databricks.com"]
}

variable "databricks_metastore_admins" {
  description = <<EOT
  List of Admins to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.admin@domain.com", "second.admin@domain.com"]
  EOT
  type        = list(string)
  default     = ["hao.wang@databricks.com"]
}

variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
  default     = "uc_admin_group_1"
}

variable "pat_ws_1" {
  type      = string
  sensitive = true
}

variable "pat_ws_2" {
  type      = string
  sensitive = true
}
