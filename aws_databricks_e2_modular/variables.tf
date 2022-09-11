variable "databricks_account_username" {
  type = string
}

variable "databricks_account_password" {
  type = string
}

variable "databricks_account_id" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "tags" {
  default = {}
}

variable "vpc_cidr" {
  default = "10.109.0.0/17"
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = ["10.109.2.0/23"]
}

variable "workspace_1_config" {
  default = {
    private_subnet_pair = { subnet1_cidr = "10.109.4.0/23", subnet2_cidr = "10.109.6.0/23" }
    workspace_name      = "test-workspace-1"
    prefix              = "ws1"
    region              = "ap-southeast-1"
  }
}

variable "workspace_2_config" {
  default = {
    private_subnet_pair = { subnet1_cidr = "10.109.8.0/23", subnet2_cidr = "10.109.10.0/23" }
    workspace_name      = "test-workspace-2"
    prefix              = "ws2"
    region              = "ap-southeast-1"
  }
}
