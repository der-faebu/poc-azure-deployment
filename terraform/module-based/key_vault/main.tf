
resource "azurerm_key_vault" "az_keyvault" {
  name                = var.key_vault_name
  location            = var.location_short
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "az_keyvault_access_policy" {
  key_vault_id = azurerm_key_vault.az_keyvault.id
  tenant_id    = azurerm_key_vault.az_keyvault.tenant_id
  object_id    = var.windows_vm_id

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
