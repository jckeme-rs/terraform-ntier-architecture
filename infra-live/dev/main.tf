module "base_infra" {
  source = "../../terraform-modules/supermodules/base_infrastructure/"

  # Generic Variables for the Deployment
  company     = "someClient"
  environment = "dev"
  app_name    = "someapplication"
  az_region   = "eastus2"
  custom_tags = {}

  vnet_address_space = ["10.0.0.0/16"]

  example_subnet_prefix = ["10.1.16.0/20"]

  enable_vm_backup = false

  enable_subnet_nsg = false
}