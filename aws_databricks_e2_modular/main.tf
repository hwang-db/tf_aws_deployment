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
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  source             = "./modules/mws_network"
  aws_nat_gateway_id = aws_nat_gateway.nat_gateways[0].id
  existing_vpc_id    = aws_vpc.mainvpc.id
  security_group_ids = [aws_security_group.test_sg.id]
  # from workspace config var
  databricks_account_id = var.databricks_account_id
  region                = var.workspace_1_config.region
  private_subnet_pair   = [var.workspace_1_config.private_subnet_pair.subnet1_cidr, var.workspace_1_config.private_subnet_pair.subnet2_cidr]
  prefix                = "${var.workspace_1_config.prefix}-${local.prefix}"
}

module "my_root_bucket" {
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  source                = "./modules/mws_storage"
  databricks_account_id = var.databricks_account_id
  region                = var.workspace_1_config.region
  root_bucket_name      = "${var.workspace_1_config.prefix}-${local.root_bucket_name}"
}

module "workspace1" {
  source = "./modules/mws_workspace"
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  databricks_account_id    = var.databricks_account_id
  workspace_name           = var.workspace_1_config.workspace_name
  region                   = var.workspace_1_config.region
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = module.my_root_bucket.storage_configuration_id
  network_id               = module.my_mws_network.network_id
}

// second workspace

module "my_mws_network2" {
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  source             = "./modules/mws_network"
  aws_nat_gateway_id = aws_nat_gateway.nat_gateways[0].id
  existing_vpc_id    = aws_vpc.mainvpc.id
  security_group_ids = [aws_security_group.test_sg.id]
  # from workspace config var
  databricks_account_id = var.databricks_account_id
  region                = var.workspace_2_config.region
  private_subnet_pair   = [var.workspace_2_config.private_subnet_pair.subnet1_cidr, var.workspace_2_config.private_subnet_pair.subnet2_cidr]
  prefix                = "${var.workspace_2_config.prefix}-${local.prefix}"
}

module "my_root_bucket2" {
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  source                = "./modules/mws_storage"
  databricks_account_id = var.databricks_account_id
  region                = var.workspace_2_config.region
  root_bucket_name      = "${var.workspace_2_config.prefix}-${local.root_bucket_name}"
}

module "workspace2" {
  source = "./modules/mws_workspace"
  providers = {
    databricks = databricks.mws
    aws        = aws
  }

  databricks_account_id    = var.databricks_account_id
  workspace_name           = var.workspace_2_config.workspace_name
  region                   = var.workspace_2_config.region
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = module.my_root_bucket.storage_configuration_id
  network_id               = module.my_mws_network.network_id
}

// create PAT token to provision entities within workspace
resource "databricks_token" "pat" {
  provider         = databricks.created_workspace
  comment          = "Terraform Provisioning"
  lifetime_seconds = 86400
}
