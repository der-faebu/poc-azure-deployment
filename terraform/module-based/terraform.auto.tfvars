# This file should not be checked into source control (add to .gitignore)
subscription_id = "ca40ebab-e130-4eb4-aa90-e52a2cc4bc9e"
tenant_id       = "76eaa1e5-b368-4d41-bf0a-b2078e6eb434"
## globalsettings
global_settings = {
  #Set of tags
  tags = {
    applicationName = "github-runner-vm"
    businessUnit    = "perigon-customer1"
    deploymentType  = "Terraform"
    environment     = "dev"
    maintainer      = "terraform-maintained"
    version         = "0.1"
  }
}
# Desktop VM variables
win_vm_image_publisher = "MicrosoftWindowsDesktop"
win_vm_image_offer     = "Windows-11"
win_vm_image_sku       = "win11-22h2-pro"
win_vm_image_version   = "latest"
win_vm_size            = "Standard_B2s"

# Server VM Variables
linux_vm_image_publisher = "canonical"                    #Publisher ID
linux_vm_image_offer     = "0001-com-ubuntu-server-jammy" #Product ID
linux_vm_image_sku       = "22_04-lts"                    #Plan ID
linux_vm_image_version   = "latest"
linux_vm_size            = "Standard_B2s"

location       = "West Europe"
location_short = "westeurope"
sloc           = "euw"

vm_adminpassword = "P@55w0Rd!"
resource_group_name = "rg-deployment"
vnet_name = "vnet-deployment"
nsg_name = "nsg-deployment"
key_vault_name = "kv-deployment"
customer_name = "perigon-customer1"