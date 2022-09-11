resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6

}

locals {
  prefix           = "demo${random_string.naming.result}"
  root_bucket_name = "${random_string.naming.result}-rootbucket"
  /*
  # get subnets pairs from variables
  mws_networks_configs = {
    private_subnet_1 = var.private_subnets_cidr[0]
    private_subnet_2 = var.private_subnets_cidr[1]
  }

  workspaces = {
    "ws1" = { vm_size = "small", zone = "a" },
    "ws2" = { vm_size = "small", zone = "b" },
    "ws3" = { vm_size = "small", zone = "c" }
  }

  for_each = local.vms
  name     = each.key
  zone     = each.zone
*/

}


module "my_mws_network" {
  source                      = "./modules/mws_network"
  existing_vpc_id             = aws_vpc.mainvpc.id
  databricks_account_username = var.databricks_account_username
  databricks_account_password = var.databricks_account_password
  databricks_account_id       = var.databricks_account_id
  region                      = var.region
  aws_nat_gateway_id          = aws_nat_gateway.nat_gateways[0].id
  private_subnet_pair         = var.private_subnet_pair
  security_group_ids          = [aws_security_group.test_sg.id]
  prefix                      = local.prefix
}

module "my_root_bucket" {
  source                      = "./modules/mws_storage"
  databricks_account_username = var.databricks_account_username
  databricks_account_password = var.databricks_account_password
  databricks_account_id       = var.databricks_account_id
  root_bucket_name            = local.root_bucket_name
  region                      = var.region
}

// create PAT token to provision entities within workspace
resource "databricks_token" "pat" {
  provider         = databricks.created_workspace
  comment          = "Terraform Provisioning"
  lifetime_seconds = 86400
}


module "workspace1" {
  source = "./modules/mws_workspace"
  providers = {
    databricks = databricks.mws
  }

  databricks_account_id       = var.databricks_account_id
  databricks_account_password = var.databricks_account_password
  databricks_account_username = var.databricks_account_username
  workspace_name              = local.prefix
  region                      = var.region
  credentials_id              = databricks_mws_credentials.this.credentials_id
  storage_configuration_id    = module.my_root_bucket.storage_configuration_id
  network_id                  = module.my_mws_network.network_id
}
