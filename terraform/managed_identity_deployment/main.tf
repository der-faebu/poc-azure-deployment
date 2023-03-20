## setup
resource "random_string" "key_vault_prefix" {
  keepers = {
    key_vault_name = var.key_vault_name
  }
  length  = 5
  upper   = false
  special = false
}
## rg
resource "azurerm_resource_group" "deployment" {
  location = var.resource_group_location_short
  name     = var.resource_group_name
}
## network
# vnet
resource "azurerm_virtual_network" "deployemnt_vnet" {
  name                = "${azurerm_resource_group.deployment.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location_short
  resource_group_name = azurerm_resource_group.deployment.name
}
# subnet
resource "azurerm_subnet" "deployment_subnet" {
  name                 = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-subnet"
  resource_group_name  = azurerm_resource_group.deployment.name
  virtual_network_name = azurerm_virtual_network.deployemnt_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
# public IPs
resource "azurerm_public_ip" "deployment_pip" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-pip"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.domain_name_label
}
# Network Security Group and rule
resource "azurerm_network_security_group" "deployment-nsg" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-deployment-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "185.40.216.73"
    destination_address_prefix = "*"
  }
}
# network interface
resource "azurerm_network_interface" "deployemnt_nic" {
  name                = "${azurerm_resource_group.deployment.name}-${azurerm_virtual_network.deployemnt_vnet.name}-deployment-nic"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.deployment.name

  ip_configuration {
    name                          = "deployment_ip_config"
    subnet_id                     = azurerm_subnet.deployment_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.deployment_pip.id
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.deployemnt_nic.id
  network_security_group_id = azurerm_network_security_group.deployment-nsg.id
}

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
    admin_username = "azureuser"
    computer_name  = var.vm_name
  }
  os_profile_windows_config {
    enable_automatic_upgrades = true
  }
  delete_os_disk_on_termination    = var.vm_os_disk_delete_flag
  delete_data_disks_on_termination = var.vm_data_disk_delete_flag
}
## keyvault


resource "azurerm_key_vault" "az_keyvault" {
  name                = "${random_string.key_vault_prefix.id}${var.key_vault_name}"
  location            = var.resource_group_location_short
  resource_group_name = azurerm_resource_group.deployment.name
  tenant_id           = var.tenant_id
  tags                = merge(var.global_settings.tags, var.key_vault_tags)
  sku_name            = lower(var.key_vault_sku)
  depends_on = [
    azurerm_resource_group.deployment
  ]
}

resource "azurerm_key_vault_access_policy" "az_keyvault_access_policy" {
  depends_on = [
    azurerm_virtual_machine.deployment-win11
  ]
  key_vault_id = azurerm_key_vault.az_keyvault.id
  tenant_id    = azurerm_key_vault.az_keyvault.tenant_id
  object_id    = azurerm_virtual_machine.deployment-win11.identity[0].principal_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore",
  ]

  secret_permissions = [
    "Get", "List", "Delete", "Recover", "Backup", "Restore", "Set",
  ]

  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "DeleteIssuers", "GetIssuers", "ListIssuers", "ManageContacts", "ManageIssuers", "SetIssuers",
  ]
}
