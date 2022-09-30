// Create UC metastore
resource "databricks_metastore" "this" {
  provider      = databricks.ws1
  name          = "primary"
  storage_root  = "s3://${aws_s3_bucket.metastore.id}/metastore"
  owner         = var.unity_admin_group
  force_destroy = true
}

resource "databricks_metastore_data_access" "this" {
  provider     = databricks.ws1
  metastore_id = databricks_metastore.this.id
  name         = aws_iam_role.metastore_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.metastore_data_access.arn
  }
  is_default = true
}

resource "databricks_metastore_assignment" "default_metastore" {
  provider             = databricks.ws1
  for_each             = toset(var.databricks_workspace_ids)
  workspace_id         = each.key
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}

// metastore - catalog - schema - table
resource "databricks_catalog" "sandbox" {
  provider     = databricks.ws1
  metastore_id = databricks_metastore.this.id
  name         = "sandbox_catalog"
  comment      = "this catalog is managed by terraform"
  properties = {
    purpose = "testing"
  }
  depends_on = [databricks_metastore_assignment.default_metastore]
}

resource "databricks_grants" "sandbox" {
  provider = databricks.ws1
  catalog  = databricks_catalog.sandbox.name
  grant {
    principal  = "account users" // account users 
    privileges = ["USAGE", "CREATE"]
  }
}

resource "databricks_schema" "things" {
  provider     = databricks.ws1
  catalog_name = databricks_catalog.sandbox.id
  name         = "schema_sample"
  comment      = "this database is managed by terraform"
  properties = {
    kind = "various"
  }
}

resource "databricks_grants" "things" {
  provider = databricks.ws1
  schema   = databricks_schema.things.id
  grant {
    principal  = "account users"
    privileges = ["USAGE", "CREATE"]
  }
}
