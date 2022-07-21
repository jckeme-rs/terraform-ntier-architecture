# Generic Variables for the Deployment
variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to the resource."
}
variable "custom_tags" {
  type        = map(string)
  description = "Specific tags that is not covered in common tags"
  default     = null
}
#Variables for Resources
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "vnet_name" {
  type        = string
  description = "Name of the vnet to create"
}
variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}
variable "subnet_prefixes" {
  type        = list(string)
  description = "IP CIDR for the new subnet"
}
variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet. "
  default     = null
}
variable "subnet_has_private_endpoints" {
  type        = bool
  description = "Enable or Disable network policies for the private link endpoint on the subnet."
  default     = null
}
variable "subnet_has_private_services" {
  type        = bool
  description = "Enable or Disable network policies for the private link service on the subnet."
  default     = null
}

variable "enable_subnet_delegation" {
  type        = bool
  description = "Toggle to Enable/Disable Subnet Delegation"
  default     = false
}
variable "services_to_delegate" {
  type        = string
  description = "A name for this delegation."
  default     = null
}
variable "actions" {
  type        = list(string)
  description = "A list of Actions which should be delegated. This list is specific to the service to delegate to."
  default     = null
}

variable "nsg_rules" {
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = string
    destination_port_range       = string
    destination_port_ranges      = string
    source_address_prefix        = string
    source_address_prefixes      = string
    destination_address_prefix   = string
    destination_address_prefixes = string
  }))
}
variable "enable_nsg" {
  type        = bool
  description = "Toggle to Create or Not-Create an NSG for the subnet"
  default     = true
}

variable "create_route_table" {
  type        = bool
  description = "Toggle to Create or Not-Create a Route Table for the subnet"
  default     = false
}

variable "rt_routes" {
  type        = any
  default     = []
  description = "List of objects representing routes."
}