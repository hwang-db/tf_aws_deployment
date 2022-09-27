locals { // hard coded values, using this repo's directory structure
  json_files = fileset("${path.root}/../aws_databricks_modular_privatelink/artifacts", "*.json")
  json_data_map = tomap({
    for k, f in local.json_files : k => jsondecode(file("${path.root}/../aws_databricks_modular_privatelink/artifacts/${f}"))
  })

  allow_lists_map = tomap({
    for k, ws in local.json_data_map : trimsuffix(k, ".json") => ws.allow_list
  })

  block_lists_map = tomap({
    for k, ws in local.json_data_map : trimsuffix(k, ".json") => ws.block_list
  })
}

module "ip_access_list_workspace_1" {
  providers = {
    databricks = databricks.ws1 // manually adding each workspace's module
  }

  source     = "./modules/ip_access_list"
  allow_list = local.allow_lists_map.workspace_1
  block_list = local.block_lists_map.workspace_1
}


module "ip_access_list_workspace_2" {
  providers = {
    databricks = databricks.ws2
  }

  source     = "./modules/ip_access_list"
  allow_list = local.allow_lists_map.workspace_2
  block_list = local.block_lists_map.workspace_2
}
