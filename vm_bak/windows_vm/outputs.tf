output "windows_vm_id" {
  value = azurerm_virtual_machine.windows_vm[*].id
}
output "windows_vm_name" {
  value = azurerm_virtual_machine.windows_vm[*].name
}
output "windows_vm_location" {
  value = azurerm_virtual_machine.windows_vm.location
}
output "windows_vm_resource_group_name" {
  value = azurerm_virtual_machine.windows_vm.resource_group_name
}

