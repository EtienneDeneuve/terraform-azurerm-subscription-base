###################################
## Outputs
###################################
output "network_resource_group_name" {
  value = "${azurerm_resource_group.network_resource_group.name}"
}

output "location" {
  value = "${var.location}"
}

output "vnet_id" {
  value = "${azurerm_virtual_network.vn.id}"
}

output "vnet_name" {
  value = "${azurerm_virtual_network.vn.name}"
}

output "data_subnet_id" {
  value = "${azurerm_subnet.data.id}"
}

output "app_subnet_id" {
  value = "${azurerm_subnet.app.id}"
}

output "web_subnet_id" {
  value = "${azurerm_subnet.web.id}"
}

output "dns_resource_group_name" {
  value = "${azurerm_resource_group.dns_rg.name}"
}

output "dns_zone_name" {
  value = "${azurerm_dns_zone.tenant_subdomain.name}"
}

output "dns_zone_id" {
  value = "${azurerm_dns_zone.tenant_subdomain.id}"
}

output "dns_zone_name_servers" {
  value = "${azurerm_dns_zone.tenant_subdomain.name_servers}"
}
