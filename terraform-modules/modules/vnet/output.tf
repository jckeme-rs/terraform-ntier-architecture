output "vnet_id" {
  value = azurerm_virtual_network.base.id
}
output "vnet_name" {
  value = azurerm_virtual_network.base.name
}
output "vnet_rsg" {
  value = azurerm_virtual_network.base.resource_group_name
}
output "vnet_location" {
  value = azurerm_virtual_network.base.location
}
output "vnet_address_space" {
  value = azurerm_virtual_network.base.address_space
}