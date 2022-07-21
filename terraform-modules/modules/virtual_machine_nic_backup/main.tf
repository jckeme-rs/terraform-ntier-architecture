resource "azurerm_network_interface" "alpha" {
  name                = join("-", [var.virtual_machine_name, "vnic"])
  location            = var.az_region
  resource_group_name = var.rsg_name

  ip_configuration {
    name                          = join("-", [var.virtual_machine_name, "vnic-config"])
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(var.common_tags, var.custom_tags)
}

resource "azurerm_virtual_machine" "new" {
  name                = var.virtual_machine_name
  location            = var.az_region
  resource_group_name = var.rsg_name
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = join("-", [var.virtual_machine_name, "os-disk1"])
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  identity {
    type         = "SystemAssigned"
  }

  network_interface_ids = [azurerm_network_interface.alpha.id]

  tags = merge(var.common_tags, var.custom_tags)
}

resource "azurerm_recovery_services_vault" "new" {
  count = var.enable_vm_backup ? 1 : 0

  name                = join("-", [var.virtual_machine_name, "example-vault"])
  location            = var.az_region
  resource_group_name = var.rsg_name
  sku                 = "Standard"

  storage_mode_type = "LocallyRedundant"
}

resource "azurerm_backup_policy_vm" "new" {
  count = var.enable_vm_backup ? 1 : 0

  name                = join("-", [var.virtual_machine_name, "example-vm-backup-policy"])
  resource_group_name = var.rsg_name
  recovery_vault_name = azurerm_recovery_services_vault.new[0].name

 backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

 retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }
  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }
  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

resource "azurerm_backup_protected_vm" "vm" {
  count = var.enable_vm_backup ? 1 : 0
  resource_group_name = var.rsg_name
  recovery_vault_name = azurerm_recovery_services_vault.new[0].name
  source_vm_id        = azurerm_virtual_machine.new.id
  backup_policy_id    = azurerm_backup_policy_vm.new[0].id
}
