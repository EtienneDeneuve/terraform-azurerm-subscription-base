###################################
## Variables
###################################
variable tenancy_name {
  type = "string"
  description = "The name of the tenancy construct"
}
variable location {
  type = "string"
  description = "The Azure location of the tenancy. This will be used to name the resource groups holding tenancy resources"
}

variable environment {
  default = "dev"
  type = "string"
  description = "The environment which this tenancy is being created (nprod or prod)"
}

variable spoke {
  default = false
  type = "boolean"
  description = "Is this a Hub or Spoke Tenancy. If true, hub resources need to be passed to create the peer"
}

# Hub Connector Variables
variable hub_resource_group_name {}
variable hub_virtual_network_name {}
variable hub_virtual_network_id {}

# Network Variables
variable network_address_space {type = "list"}
variable app_address_space     {type = "string"}
variable web_address_space     {type = "string"}
variable data_address_space    {type = "string"}
variable parent_dns_record {}


locals {
  common_tags = {
    location     = "${var.location}"
    environment  = "${var.environment}"
    tenancy_name = "${var.tenancy_name}"
  }

  abreviations = {
    "Australia East" = "syd"
    "Australia Southeast" = "vic"
  }
  rg_prefix = "${lower(var.tenancy_name)}-${lower(var.environment)}-${lookup(local.abreviations, var.location, var.location)}"
  
  # Peering Names
  tenancy_to_lmz_name = "${lower(var.tenancy_name)}-to-lmz-${lower(var.environment)}"
  lmz_to_tenancy_name = "lmz-to-${lower(var.tenancy_name)}-${lower(var.environment)}"
}
