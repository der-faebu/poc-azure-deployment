
provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_certificates_on_destroy = true
      recover_soft_deleted_certificates          = true
    }
  }
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}


# Create an Azure VM cluster with Terraform calling a Module. Creates 1 for Windows 10 desktop and 1 for Windows 2019 Server.
module "github_runner_agent_windows" {
  source              = "./vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_short
  sloc                = var.sloc
  vm_subnet_id        = module.network.vnet_subnets[0]
  vm_name             = "win11-gh-agent"
  vm_size             = var.win_vm_size
  publisher           = var.win_vm_image_publisher
  offer               = var.win_vm_image_offer
  sku                 = var.win_vm_image_sku
  static_ip_address   = "10.0.1.15"
  activity_tag        = "Windows Desktop"
  admin_password      = var.vm_adminpassword
}
module "github_runner_agent_linux" {
  source              = "./vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location_short
  sloc                = var.sloc
  vm_subnet_id        = module.network.vnet_subnets[1]
  vm_name             = "linux-gh-agent"
  vm_size             = var.linux_vm_size
  publisher           = var.linux_vm_image_publisher
  offer               = var.linux_vm_image_offer
  sku                 = var.linux_vm_image_sku
  static_ip_address   = "10.0.2.15"
  activity_tag        = "Linux Server"
  admin_password      = var.vm_adminpassword
}

module "azure_key_vault" {
  source              = "./key_vault"
  key_vault_name      = var.key_vault_name
  location_short      = var.location_short
  tenant_id           = var.tenant_id
  resource_group_name = var.resource_group_name
  customer_name       = var.customer_name
  linux_vm_id         = module.github_runner_agent_linux.linux_vm_id
  windows_vm_id       = module.github_runner_agent_linux.windows_vm_id
}
