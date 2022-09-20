resource "aws_vpc_endpoint" "backend_rest" {
  vpc_id              = var.existing_vpc_id
  service_name        = var.workspace_vpce_service
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.privatelink_subnets_ids
  private_dns_enabled = true // directly set this to true in the first apply
  tags = {
    Name = "${var.workspace_name}-backend-rest"
  }
}

resource "aws_vpc_endpoint" "backend_relay" {
  vpc_id              = var.existing_vpc_id
  service_name        = var.relay_vpce_service
  vpc_endpoint_type   = "Interface"
  security_group_ids  = var.security_group_ids
  subnet_ids          = var.privatelink_subnets_ids
  private_dns_enabled = true // directly set this to true in the first apply
  tags = {
    Name = "${var.workspace_name}-backend-relay"
  }
}

// from official guide
resource "databricks_mws_vpc_endpoint" "backend_rest_vpce" {
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_rest.id
  vpc_endpoint_name   = "${var.prefix}-vpc-backend-${var.existing_vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.backend_rest]
}

resource "databricks_mws_vpc_endpoint" "relay" {
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_relay.id
  vpc_endpoint_name   = "${var.prefix}-vpc-relay-${var.existing_vpc_id}"
  region              = var.region
  depends_on          = [aws_vpc_endpoint.backend_relay]
}

// next we can build mws_network
module "my_mws_network" {
  source                = "./modules/mws_network"
  databricks_account_id = var.databricks_account_id
  aws_nat_gateway_id    = var.nat_gateways_id
  existing_vpc_id       = var.existing_vpc_id
  security_group_ids    = var.security_group_ids
  region                = var.region
  private_subnet_pair   = var.private_subnet_pair
  prefix                = "${var.prefix}-network"
  relay_vpce_id         = [databricks_mws_vpc_endpoint.relay.vpc_endpoint_id]
  rest_vpce_id          = [databricks_mws_vpc_endpoint.backend_rest_vpce.vpc_endpoint_id]
}

module "my_root_bucket" {
  source                = "./modules/mws_storage"
  databricks_account_id = var.databricks_account_id
  region                = var.region
  root_bucket_name      = var.root_bucket_name
}

resource "databricks_mws_customer_managed_keys" "workspace_storage" {
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn   = var.workspace_storage_cmk.key_arn
    key_alias = var.workspace_storage_cmk.key_alias
  }
  use_cases = ["STORAGE"]
}

resource "databricks_mws_customer_managed_keys" "managed_services" {
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn   = var.managed_services_cmk.key_arn
    key_alias = var.managed_services_cmk.key_alias
  }
  use_cases = ["MANAGED_SERVICES"]
}


resource "databricks_mws_private_access_settings" "pas" {
  account_id                   = var.databricks_account_id
  private_access_settings_name = "Private Access Settings for ${var.prefix}"
  region                       = var.region
  public_access_enabled        = true
  private_access_level         = "ACCOUNT" // a fix for recent changes - 202209
}


resource "databricks_mws_workspaces" "this" {
  account_id                 = var.databricks_account_id
  aws_region                 = var.region
  workspace_name             = var.workspace_name
  private_access_settings_id = databricks_mws_private_access_settings.pas.private_access_settings_id
  pricing_tier               = "ENTERPRISE"

  # deployment_name = local.prefix

  credentials_id           = var.credentials_id
  storage_configuration_id = module.my_root_bucket.storage_configuration_id
  network_id               = module.my_mws_network.network_id

  # cmk
  storage_customer_managed_key_id          = databricks_mws_customer_managed_keys.workspace_storage.customer_managed_key_id
  managed_services_customer_managed_key_id = databricks_mws_customer_managed_keys.managed_services.customer_managed_key_id

  depends_on = [module.my_mws_network, module.my_root_bucket]
}
