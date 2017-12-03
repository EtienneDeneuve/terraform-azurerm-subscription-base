###################################
## Outputs
###################################

output "resource_group_name" { value = "${azurerm_resource_group.network_resource_group.name}"}
output "location"          { value = "${var.location}"}
output "data_subnet_id"    { value = "${azurerm_subnet.data.id}"}
output "private_subnet_id" { value = "${azurerm_subnet.private.id}"}
output "public_subnet_id"  { value = "${azurerm_subnet.public.id}"}