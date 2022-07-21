variable "company" {
  type        = string
  description = "Company name"
}
variable "environment" {
  type        = string
  description = "Environment of the deployment"
}
variable "app_name" {
  type        = string
  description = "The name of the application associated with this deployment."
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "custom_tags" {
  type        = map(string)
  description = "Specific tags that is not covered in common tags"
  default     = null
}

# VNET Variables
variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "example_subnet_prefix" {
  type        = list(string)
  description = "The Subnet Prefix"
}

variable "enable_vm_backup" {
  type        = bool
  description = "Toggle to enable/disable VM backup and resources"
}

variable "enable_subnet_nsg" {
  type        = bool
  description = "Toggle to enable/disable subnet NSG"
}