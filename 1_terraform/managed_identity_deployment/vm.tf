## vms
resource "azurerm_virtual_machine" "deployment-win11" {
  name                = var.vm_name
  vm_size             = var.vm_size
  location            = var.resource_group_location_short
  resource_group_name = azurerm_resource_group.deployment.name
  tags                = merge(var.global_settings.tags, var.vm_tags)

  network_interface_ids = [
    azurerm_network_interface.deployemnt_nic.id
  ]
  storage_image_reference {
    publisher = var.os_image_publisher
    offer     = var.os_image_offer
    sku       = var.os_image_sku
    version   = "latest"
  }
  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "${var.vm_name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    admin_password = var.vm_admin_password
    admin_username = var.vm_admin_name
    computer_name  = var.vm_name
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
  }
  delete_os_disk_on_termination    = var.vm_os_disk_delete_flag
  delete_data_disks_on_termination = var.vm_data_disk_delete_flag
}

resource "azurerm_role_assignment" "manage_identity_key_vault_read" {
  scope                = azurerm_key_vault.az_managed_identity_key_vault.id
  role_definition_name = "Reader"
  principal_id         = azurerm_virtual_machine.deployment-win11.identity[0].principal_id
}
