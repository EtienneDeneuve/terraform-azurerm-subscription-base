###################################
## Virtual Network - VNet & Subnets 
###################################
resource "azurerm_resource_group" "network_resource_group" {
  name     = "${local.rg_prefix}-network"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}

resource "azurerm_virtual_network" "vn" {
  name                = "${lower(var.account_name)}"
  resource_group_name = "${azurerm_resource_group.network_resource_group.name}"
  address_space       = "${var.network_address_space}"
  location            = "${var.location}"
  tags                = "${local.common_tags}"
}

resource "azurerm_subnet" "web" {
  name                 = "public"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.public_address_space}"
  resource_group_name  = "${azurerm_resource_group.network_resource_group.name}"
  tags     = "${merge(local.common_tags, map("subnet_role", "web"))}"
}

resource "azurerm_subnet" "app" {
  name                 = "private"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.private_address_space}"
  resource_group_name = "${azurerm_resource_group.network_resource_group.name}"
  tags     = "${merge(local.common_tags, map("subnet_role", "app"))}"
}

resource "azurerm_subnet" "data" {
  name                 = "data"
  virtual_network_name = "${azurerm_virtual_network.vn.name}"
  address_prefix       = "${var.data_address_space}"
  resource_group_name = "${azurerm_resource_group.network_resource_group.name}"
  tags     = "${merge(local.common_tags, map("subnet_role", "data"))}"
}

###################################
## Virtual Network - Peerings 
###################################
resource "azurerm_virtual_network_peering" "tenancy_to_lmz" {
  name                      = "${local.tenancy_to_lmz_name}"
  resource_group_name       = "${azurerm_resource_group.network_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.vn.name}"
  remote_virtual_network_id = "${var.lmz_virtual_network_id}"
}

resource "azurerm_virtual_network_peering" "lmz_to_tenancy" {
  name                      = "${local.lmz_to_tenancy_name}"
  resource_group_name       = "${var.lmz_resource_group_name}"
  virtual_network_name      = "${var.lmz_virtual_network_name}"
  remote_virtual_network_id = "${azurerm_resource_group.network_resource_group.id}"
}

###################################
## DNS Zone
###################################
resource "azurerm_resource_group" "dns_rg" {
  name     = "${var.account_name}"
  location = "${var.location}"
  tags     = "${local.common_tags}"
}

resource "azurerm_dns_zone" "tenant_subdomain" {
  name                = "${var.tenancy_name}.${var.parent_dns_record}"
  resource_group_name = "${azurerm_resource_group.dns_rg.name}"
  tags                = "${local.common_tags}"
}

###################################
## Create Lookup in Parent
###################################
resource "azurerm_dns_ns_record" "subdomain_ns_allocation" {
  name                = "${var.tenancy_name}"
  zone_name           = "${var.parent_dns_record}"
  resource_group_name = "${var.lmz_resource_group_name}"
  ttl                 = 300

  record {
    count = "${length(azurerm_dns_zone.tenant_subdomain.name_servers)}"
    nsdname = "${element(azurerm_dns_zone.tenant_subdomain.*.name_servers, count.index)}"
  }

  tags = "${local.common_tags}"
}
