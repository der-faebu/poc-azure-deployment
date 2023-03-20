
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
  source   = "./vm"
  for_each = { for vm in var.vm_agents.windows_agents : vm.win_vm_name => vm }

  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location_short
  sloc                      = var.sloc
  vm_subnet_id              = module.network.vnet_subnets[0]
  vm_name                   = each.value.win_vm_name
  vm_size                   = each.value.win_vm_size
  publisher                 = each.value.win_vm_image_publisher
  offer                     = each.value.win_vm_image_offer
  sku                       = each.value.win_vm_image_sku
  activity_tag              = "Windows Desktop"
  admin_password            = each.value.win_vm_adminpassword
  ip_configuration          = each.value.ip_configuration
  windows_os_profile_config = each.value.windows_os_profile_config
}


module "github_runner_agent_linux" {
  source   = "./vm"
  for_each = { for vm in var.vm_agents.linux_agents : vm.linux_vm_name => vm }

  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location_short
  sloc                    = var.sloc
  vm_subnet_id            = module.network.vnet_subnets[0]
  vm_name                 = each.value.linux_vm_name
  vm_size                 = each.value.linux_vm_size
  publisher               = each.value.linux_vm_image_publisher
  offer                   = each.value.linux_vm_image_offer
  sku                     = each.value.linux_vm_image_sku
  activity_tag            = "Linux Server"
  admin_password          = each.value.linux_vm_adminpassword
  ip_configuration        = each.value.ip_configuration
  linux_os_profile_config = each.value.linux_os_profile_config
}
