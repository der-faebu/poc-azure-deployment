# This file should not be checked into source control (add to .gitignore)
#tenant
subscription_id = "ca40ebab-e130-4eb4-aa90-e52a2cc4bc9e"
tenant_id       = "76eaa1e5-b368-4d41-bf0a-b2078e6eb434"
customer_name   = "Perigoncloud Customer 1"
customer_id     = "perigoncloud-cust1.ch"
# global settings
global_settings = {
  tags = {
    custoemrName   = "perigon-customer1"
    businessUnit   = "devOps"
    deploymentType = "Terraform"
    environment    = "dev"
    maintainer     = "terraform-maintained"
    version        = "0.1"
    createdBy      = "gfa"
  }
}

# rg
resource_group_location       = "West Europe"
resource_group_location_short = "westeurope"
resource_group_name           = "rg-m365-deployment"
resource_group_tags = {
}
# network
domain_name_label = "perigon-cust1-test"

# vm
vm_name                  = "win11-gh-runner"
vm_size                  = "Standard_B2s"
vm_admin_name            = "github-runner"
vm_admin_password        = "P@55w0Rd!"
vm_data_disk_delete_flag = true
vm_os_disk_delete_flag   = true
os_image_publisher       = "MicrosoftWindowsDesktop"
os_image_offer           = "Windows-11"
os_image_sku             = "win11-22h2-pro"
vm_tags = {
  os    = "windows"
  usage = "deployment"
}

# key vault
key_vault_name = "deployment"
key_vault_sku  = "Standard"
key_vault_tags = {
  usage = "m365DSC_sp_auth"
}

