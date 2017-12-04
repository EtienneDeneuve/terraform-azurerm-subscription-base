###################################
## Virtual Network - VNet & Subnets 
###################################
resource "azurerm_resource_group" "network_resource_group" {
  alias    = "azurerm.base"
  name     = "${local.rg_prefix}-network"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}

resource "azurerm_virtual_network" "vn" {
  alias    = "azurerm.base"
  name                = "${lower(var.tenancy_name)}"
  resource_group_name = "${azurerm_resource_group.network_resource_group.name}"
  address_space       = ["${var.network_address_space}"]
  location            = "${var.location}"
  tags                = "${local.common_tags}"
}

resource "azurerm_subnet" "web" {
  alias    = "azurerm.base"
  name                 = "web"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.web_address_space}"
  resource_group_name  = "${azurerm_resource_group.network_resource_group.name}"
}

resource "azurerm_subnet" "app" {
  alias    = "azurerm.base"
  name                 = "app"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.app_address_space}"
  resource_group_name  = "${azurerm_resource_group.network_resource_group.name}"
}

resource "azurerm_subnet" "data" {
  alias    = "azurerm.base"
  name                 = "data"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.data_address_space}"
  resource_group_name  = "${azurerm_resource_group.network_resource_group.name}"
}

###################################
## Virtual Network - Peerings (SPOKE ONLY)
###################################

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  alias    = "azurerm.base"
  count                     = "${var.spoke ? 1 : 0}"
  name                      = "${local.tenancy_to_hub_name}"
  resource_group_name       = "${azurerm_resource_group.network_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.vn.name}"
  remote_virtual_network_id = "${var.hub_virtual_network_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit = false
  use_remote_gateways = false
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  alias    = "azurerm.parent"
  count                     = "${var.spoke ? 1 : 0}"
  name                      = "${local.hub_to_tenancy_name}"
  resource_group_name       = "${var.hub_network_resource_group_name}"
  virtual_network_name      = "${var.hub_virtual_network_name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vn.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

###################################
## DNS Zone
###################################
resource "azurerm_resource_group" "dns_rg" {
  alias    = "azurerm.base"
  name     = "${local.rg_prefix}-dns"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}

resource "azurerm_dns_zone" "tenant_subdomain" {
  alias    = "azurerm.base"
  name                = "${var.tenancy_name}.${var.parent_domain_name}"
  resource_group_name = "${azurerm_resource_group.dns_rg.name}"
  tags                = "${local.common_tags}"
}

resource "azurerm_dns_zone" "parent_subdomain" {
  alias    = "azurerm.base"
  count               = "${var.spoke ? 0 : 1 }"
  name                = "${var.parent_domain_name}"
  resource_group_name = "${azurerm_resource_group.dns_rg.name}"
  tags                = "${local.common_tags}"
}

###################################
## DNS Zone - Subdomain NS Record (SPOKE ONLY)
###################################
resource "azurerm_dns_ns_record" "subdomain_ns_allocation" {
  alias    = "azurerm.parent"
  count               = "${var.spoke ? 1 : 0}"
  name                = "${var.tenancy_name}"
  zone_name           = "${var.parent_domain_name}"
  resource_group_name = "${var.hub_dns_resource_group_name}"
  ttl                 = 300

  record {
    nsdname = "${element(azurerm_dns_zone.tenant_subdomain.name_servers, 0)}"
  }

  record {
    nsdname = "${element(azurerm_dns_zone.tenant_subdomain.name_servers, 1)}"
  }

  record {
    nsdname = "${element(azurerm_dns_zone.tenant_subdomain.name_servers, 2)}"
  }

  record {
    nsdname = "${element(azurerm_dns_zone.tenant_subdomain.name_servers, 3)}"
  }

}
