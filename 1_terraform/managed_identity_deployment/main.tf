data "azuread_client_config" "current" {}


## setup
resource "random_string" "key_vault_prefix" {
  keepers = {
    key_vault_name = var.key_vault_name
  }
  length  = 5
  upper   = false
  special = false
}
