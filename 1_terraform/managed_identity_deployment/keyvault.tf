## keyvault
resource "azurerm_key_vault" "az_managed_identity_key_vault" {
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

resource "azurerm_key_vault_access_policy" "az_managed_identity_key_vault_access_policy_managed_identity" {
  depends_on = [
    azurerm_virtual_machine.deployment-win11
  ]
  key_vault_id = azurerm_key_vault.az_managed_identity_key_vault.id
  tenant_id    = azurerm_key_vault.az_managed_identity_key_vault.tenant_id
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
