variable "resource_group_name" {
}
variable "location" {
}
variable "sloc" {
}
variable "vm_size" {
  default = "Standard_B2s"
}
variable "vm_subnet_id" {
}
variable "vm_name" {
}
variable "vm_os_disk_delete_flag" {
  default = true
}
variable "vm_data_disk_delete_flag" {
  default = true
}
variable "network_security_group_id" {
  default = ""
}

variable "ip_configuration" {
  default = {
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = ""
  }
}
variable "publisher" {
}
variable "offer" {
}
variable "sku" {
}
variable "tags" {
  type        = map(any)
  description = "All mandatory tags to use on all assets"
  default = {
    activityName       = "AzureVMWindowsDemo"
    automation         = "Terraform"
    costCenter1        = "A00000"
    dataClassification = "Demo"
    managedBy          = "example@test.com"
    solutionOwner      = "example@test.com"
  }
}
variable "activity_tag" {
}
variable "admin_password" {
}
variable "windows_config" {
  default = {
    disable_password_authentication = false
    ssh_keys                        = []
  }
}
