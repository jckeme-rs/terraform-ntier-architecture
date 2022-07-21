resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rsg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_prefixes
  service_endpoints    = var.service_endpoints == "" ? null : var.service_endpoints

  enforce_private_link_endpoint_network_policies = var.subnet_has_private_endpoints ? var.subnet_has_private_endpoints : null

  enforce_private_link_service_network_policies = var.subnet_has_private_services ? var.subnet_has_private_services : null

  dynamic "delegation" {
    for_each = toset(var.enable_subnet_delegation ? ["1"] : [])

    content {
      name = "delegation"

      service_delegation {
        name    = var.services_to_delegate
        actions = var.actions
      }
    }
  }

}

resource "azurerm_network_security_group" "nsg" {
  count               = var.enable_nsg ? 1 : 0
  name                = join("-", [azurerm_subnet.subnet.name, "nsg"])
  location            = var.az_region
  resource_group_name = var.rsg_name

  tags = merge(var.common_tags, var.custom_tags)

  depends_on = [
    azurerm_subnet.subnet
  ]
}


resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  count                     = var.enable_nsg ? 1 : 0
  network_security_group_id = azurerm_network_security_group.nsg.0.id
  subnet_id                 = azurerm_subnet.subnet.id

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each  = { for rule in var.nsg_rules : rule.name => rule }
  name      = each.value.name
  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range = each.value.source_port_ranges == "" ? null : each.value.source_port_ranges

  destination_port_range = each.value.destination_port_range == "" ? null : each.value.destination_port_range

  destination_port_ranges = length(each.value.destination_port_ranges) > 0 ? split(",", each.value.destination_port_ranges) : null

  source_address_prefix = each.value.source_address_prefix == "" ? null : each.value.source_address_prefix

  source_address_prefixes = length(each.value.source_address_prefixes) > 0 ? split(",", replace(each.value.source_address_prefixes, " ", "")) : null

  destination_address_prefix = each.value.destination_address_prefix == "" ? null : each.value.destination_address_prefix

  destination_address_prefixes = length(each.value.destination_address_prefixes) > 0 ? split(",", replace(each.value.destination_address_prefixes, " ", "")) : null

  resource_group_name         = var.rsg_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_subnet.subnet
  ]
  
}

resource "azurerm_route_table" "route_table" {
  count               = var.create_route_table ? 1 : 0
  name                = join("-", [azurerm_subnet.subnet.name, "rt"])
  location            = var.az_region
  resource_group_name = var.rsg_name

  disable_bgp_route_propagation = false

  tags = merge(var.common_tags, var.custom_tags)

  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_subnet_route_table_association" "rt_to_subnet" {
  count          = var.create_route_table ? 1 : 0
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.route_table.0.id

  depends_on = [
    azurerm_route_table.route_table,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_route" "routes" {
  for_each = try(({ for route in var.rt_routes : route.name => route }), [])

  name                   = try(each.value.name, null)
  address_prefix         = try(each.value.address_prefix, null)
  next_hop_type          = try(each.value.next_hop_type, null)
  next_hop_in_ip_address = each.value.next_hop_in_ip_address == "" ? null : each.value.next_hop_in_ip_address

  resource_group_name = var.rsg_name
  route_table_name    = azurerm_route_table.route_table.0.name

  depends_on = [
    azurerm_route_table.route_table,
    azurerm_subnet.subnet
  ]

}