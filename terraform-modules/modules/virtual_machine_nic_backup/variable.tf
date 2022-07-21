# Generic Variables for the deployment
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
  description = "The name of the Resource Group for this deployment"
}

# Variables for Virtual Machine
variable "virtual_machine_name" {
  type        = string
  description = "Specifies the name of the Virtual Machine."
}
variable "admin_username" {
  type        = string
  description = "The username of the local administrator used for the Virtual Machine."
}
variable "admin_password" {
  type        = string
  description = "The Password which should be used for the local-administrator on this Virtual Machine."
}

# Storage OS Disk
variable "storage_account_type" {
  type        = string
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created."
  default     = "Standard_LRS"
}

# Network Setting
variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where the VM will be provisioned."
}

# Recovery Service Vault Variables
variable "enable_vm_backup" {
  type        = bool
  description = "True if an existing recovery vault will be used for this VM."
  default     = false
}
