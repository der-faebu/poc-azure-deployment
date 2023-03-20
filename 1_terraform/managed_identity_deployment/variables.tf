variable "tenant_id" {
}
variable "subscription_id" {
}
variable "customer_name" {
}
variable "global_settings" {
  type = object({
    tags = map(any)
  })
}
variable "customer_id" {
}
variable "resource_group_location" {
  type        = string
  default     = "eu-west"
  description = "Location of the resource group."
}
variable "resource_group_location_short" {
  type        = string
  default     = "euw"
  description = "Short notation of the location of the resource group."
}

variable "resource_group_name" {
}

variable "domain_name_label" {
}

# vm
variable "vm_name" {
}
variable "vm_size" {
  default = "Standard_B2s"
}
variable "vm_admin_name" {
}
variable "vm_admin_password" {
}
variable "vm_os_disk_delete_flag" {
}
variable "vm_data_disk_delete_flag" {
}
variable "os_image_publisher" {
}
variable "os_image_offer" {
}
variable "os_image_sku" {
}
variable "vm_tags" {
  type        = map(any)
  description = "VM specific tags"
}

# nsg
variable "network_security_group_id" {
  default = ""
}

# key vault
variable "key_vault_name" {
}

variable "key_vault_tags" {
  type        = map(any)
  description = "Key vault specific tags"
}

variable "key_vault_sku" {
  type = string
}
