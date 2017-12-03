###################################
## Variables
###################################
variable tenancy_name {
  type        = "string"
  description = "The name of the tenancy construct"
}

variable location {
  type        = "string"
  description = "The Azure location of the tenancy. This will be used to name the resource groups holding tenancy resources"
}

variable environment {
  default     = "dev"
  type        = "string"
  description = "The environment which this tenancy is being created (nprod or prod)"
}

variable additional_tags {
  default     = {}
  type        = "map"
  description = "Additional tags to be included with the resources"
}

# Network Variables
variable network_address_space {
  type        = "string"
  description = "The Network address space of the VNET. MUST NOT overlap with any other Hubs/Spokes on the network, else peering will fail"
}

variable app_address_space {
  type        = "string"
  description = "Address space of the Application Subnet"
}

variable web_address_space {
  type        = "string"
  description = "Address space of the Web Subnet"
}

variable data_address_space {
  type        = "string"
  description = "Address Space of the Data Subnet"
}

variable parent_domain_name {
  type        = "string"
  description = "DNS Record of the Hub's DNS zone"
}

###################################
## Variables
###################################
variable spoke {
  default     = false
  description = "Is this a Hub or Spoke Tenancy. If true, hub resources need to be passed to create the peer"
}

variable hub_dns_resource_group_name {
  type        = "string"
  description = "Resource group of the Hub"
  default     = ""
}

variable hub_network_resource_group_name {
  type        = "string"
  description = "Resource group of the Hub"
  default     = ""
}

variable hub_virtual_network_name {
  type        = "string"
  description = "Name of the Virtual Network in the hub"
  default     = ""
}

variable hub_virtual_network_id {
  type        = "string"
  description = "ID of the Virtual network in the hub"
  default     = ""
}

locals {
  base_tags = {
    location     = "${var.location}"
    environment  = "${var.environment}"
    tenancy_name = "${var.tenancy_name}"
  }

  common_tags = "${merge(local.base_tags, var.additional_tags)}"

  abreviations = {
    "Australia East"      = "syd"
    "Australia Southeast" = "vic"
  }

  rg_prefix = "${lower(var.tenancy_name)}-${lower(var.environment)}-${lookup(local.abreviations, var.location, var.location)}"

  # Peering Names
  tenancy_to_hub_name = "${lower(var.tenancy_name)}-to-hub-${lower(var.environment)}"
  hub_to_tenancy_name = "hub-to-${lower(var.tenancy_name)}-${lower(var.environment)}"
}
