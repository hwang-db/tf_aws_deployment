module "my_mws_network" {
  source                = "./modules/mws_network"
  databricks_account_id = var.databricks_account_id
  aws_nat_gateway_id    = var.nat_gateways_id
  existing_vpc_id       = var.existing_vpc_id
  security_group_ids    = var.security_group_ids
  region                = var.region
  private_subnet_pair   = var.private_subnet_pair
  prefix                = "${var.prefix}-network"
}

module "my_root_bucket" {
  source                = "./modules/mws_storage"
  databricks_account_id = var.databricks_account_id
  region                = var.region
  root_bucket_name      = "${var.prefix}-storage"
}

resource "databricks_mws_workspaces" "this" {
  account_id     = var.databricks_account_id
  aws_region     = var.region
  workspace_name = var.workspace_name
  # deployment_name = local.prefix

  credentials_id           = var.credentials_id
  storage_configuration_id = module.my_root_bucket.storage_configuration_id
  network_id               = module.my_mws_network.network_id
}
