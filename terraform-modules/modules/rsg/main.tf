resource "azurerm_resource_group" "deployer" {
  name     = var.rsg_name
  location = var.az_region

  tags = merge(var.common_tags, var.custom_tags)
}