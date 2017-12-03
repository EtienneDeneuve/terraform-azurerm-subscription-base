provider "azurerm" {
  alias = "hub"
  subscription_id = "..."
  client_id       = "..."
  client_secret   = "..."
  tenant_id       = "..."
}

module "hub_example" {
  source = "../../"

  tenancy_name    = "lmz"
  location        = "Australia East"
  environment     = "dev"
  additional_tags = {}

  network_address_space = "10.100.0.0/19"
  web_address_space     = "10.100.0.0/21"
  app_address_space     = "10.100.16.0/20"
  data_address_space    = "10.100.8.0/21"
  parent_domain_name    = "azure.example.com"

  spoke = false

  providers = {
    azurerm = "azurerm.hub"
  }
}

provider "azurerm" {
  alias = "spoke"
  subscription_id = "..."
  client_id       = "..."
  client_secret   = "..."
  tenant_id       = "..."
}

module "spoke_example" {
  source = "../../"

  tenancy_name    = "random_business_unit"
  location        = "Australia East"
  environment     = "dev"
  additional_tags = {}

  network_address_space = "10.101.0.0/19"
  web_address_space     = "10.101.0.0/21"
  app_address_space     = "10.101.16.0/20"
  data_address_space    = "10.101.8.0/21"
  parent_domain_name    = "azure.example.com"

  spoke                           = true
  hub_dns_resource_group_name     = "${module.hub_example.dns_resource_group_name}"
  hub_network_resource_group_name = "${module.hub_example.network_resource_group_name}"
  hub_virtual_network_name        = "${module.hub_example.vnet_name}"
  hub_virtual_network_id          = "${module.hub_example.vnet_id}"

  providers = {
    azurerm = "azurerm.spoke"
  }
}
