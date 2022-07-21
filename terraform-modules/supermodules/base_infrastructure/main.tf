locals {
  common_tags = {
    Company     = var.company
    Environment = var.environment
    Application = var.app_name
  }

  subnet_nsg_rules_csv = <<-CSV
name,priority,direction,access,protocol,source_port_ranges,destination_port_range,destination_port_ranges,source_address_prefix,source_address_prefixes,destination_address_prefix,destination_address_prefixes
CSV
  subnet_nsg_rules     = csvdecode(local.subnet_nsg_rules_csv)
}

module "rsg" {
  source = "../../modules/rsg"

  az_region = var.az_region
  rsg_name  = join("-", [var.environment, var.app_name])

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}

module "vnet" {
  source = "../../modules/vnet"

  vnet_name                = join("-", [module.rsg.name, var.az_region, "vnet"])
  vnet_address_space       = var.vnet_address_space
  az_region            = var.az_region
  rsg_name = module.rsg.name

  custom_tags = var.custom_tags
  common_tags = local.common_tags  

  depends_on = [
    module.rsg
  ]
}

module "subnet" {
  source = "../../modules/subnet_nsg_routetable"

  custom_tags = var.custom_tags
  common_tags = local.common_tags  

  az_region = var.az_region
  rsg_name  = module.rsg.name

  vnet_name = module.vnet.vnet_name

  subnet_name = join("-", [var.environment, var.app_name, "example-subnet"])

  subnet_prefixes              = var.example_subnet_prefix
  service_endpoints            = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.AzureCosmosDB", "Microsoft.ContainerRegistry", "Microsoft.ServiceBus"]
  subnet_has_private_endpoints = true
  subnet_has_private_services  = false

  enable_nsg = var.enable_subnet_nsg

  enable_subnet_delegation = false
  #services_to_delegate = "Microsoft.Web/serverFarms"
  #actions = ["Microsoft.Network/virtualNetworks/subnets/action","Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]

  nsg_rules = local.subnet_nsg_rules

}

module "virtual_machine" {
  source = "../../modules/virtual_machine_nic_backup"

  rsg_name  = module.rsg.name
  virtual_machine_name      = join("-", [var.environment, var.app_name, "example-vm"])
  az_region = var.az_region

  # NIC
  subnet_id                     = module.subnet.subnet_id

  # VM
  admin_username = "random_admin_user"
  admin_password = "va;~muV[_C$4)XC&)x*pi,Vj&%dkK@.X"

  storage_account_type = "Standard_LRS"

  # Backup
  enable_vm_backup = var.enable_vm_backup

  common_tags = local.common_tags
  custom_tags = var.custom_tags
}