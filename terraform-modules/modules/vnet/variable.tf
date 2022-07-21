variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to the resource."
  default     = null
}
variable "custom_tags" {
  type        = map(string)
  description = "Specific tags that is not covered in common tags"
  default     = null
}
variable "az_region" {
  type        = string
  description = "The location where resources will be created"
}
variable "rsg_name" {
  type        = string
  description = "The name of the resource group in which the resources will be created"
}
variable "vnet_name" {
  type        = string
  description = "Name of the vnet to create"
}
variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}