resource "azurerm_virtual_network" "base" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.az_region
  resource_group_name = var.rsg_name

  tags = merge(var.common_tags, var.custom_tags)
}
