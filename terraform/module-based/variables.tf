# read in from the terraform.auto.tfvars file
variable "subscription_id" {
}
variable "tenant_id" {
}
variable "global_settings" {
}
variable "vm_agents" {
  type = object({
    windows_agents = list(object({
      win_vm_name               = string
      win_vm_image_publisher    = string
      win_vm_image_offer        = string
      win_vm_image_sku          = string
      win_vm_image_version      = string
      win_vm_size               = string
      win_vm_adminpassword      = string
      ip_configuration          = any
      windows_os_profile_config = any
    }))
    linux_agents = list(object({
      linux_vm_name            = string
      linux_vm_image_publisher = string
      linux_vm_image_offer     = string
      linux_vm_image_sku       = string
      linux_vm_image_version   = string
      linux_vm_size            = string
      linux_vm_adminpassword   = string
      ip_configuration         = any
      linux_os_profile_config  = any
    }))
  })
}
variable "location" {
}
variable "location_short" {
}
variable "sloc" {
}
variable "vm_adminpassword" {
}
variable "resource_group_name" {
}
variable "vnet_name" {
}
variable "nsg_name" {
}
variable "key_vault_name" {
}
variable "customer_name" {
}

