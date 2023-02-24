# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.33.0"
    }
  }
  required_version = ">= 1.1.0"
}

data "azuread_client_config" "current" {}

provider "azurerm" {
  tenant_id = var.ARM_TENANT_ID
  use_msi   = true

  features {
    key_vault {
      purge_soft_deleted_certificates_on_destroy = true
      recover_soft_deleted_certificates          = true
    }
  }
}

provider "azuread" {
  tenant_id     = var.ARM_TENANT_ID
  client_id     = var.ARM_CLIENT_ID
  client_secret = var.ARM_CLIENT_SECRET

}

resource "azurerm_resource_group" "m365_dsc_sp_rg" {
  name     = "m365_dsc_sp_rg"
  location = var.LOCATION
}

resource "azurerm_key_vault" "m365_dsc_sp" {
  name                = "m365-sc-sp-keyvault"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.m365_dsc_sp_rg.name
  tenant_id           = data.azuread_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "terraform_sp_access" {
  key_vault_id = azurerm_key_vault.m365_dsc_sp.id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = data.azuread_client_config.current.object_id

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

resource "azurerm_key_vault_access_policy" "terraform_m365dcs_sp_access" {
  key_vault_id = azurerm_key_vault.m365_dsc_sp.id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = azuread_service_principal.m365_dsc_sp.object_id

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

resource "azurerm_key_vault_certificate" "m365_dsc_sp_cert" {
  name         = "m365-dsc-sp-cert"
  key_vault_id = azurerm_key_vault.m365_dsc_sp.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }
    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      # subject_alternative_names {
      #   dns_names = ["internal.contoso.com", "domain.hello.world"]
      # }

      subject            = "CN=mytest.ch"
      validity_in_months = 12
    }
  }
}

resource "azuread_application" "m365_dsc_sp_app" {
  display_name            = "m365DSC_app_registration"
  prevent_duplicate_names = true

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "741f803b-c850-494e-b5df-cde7c675a1ca" # User.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9" # Application.ReadWrite.All
      type = "Role"
    }
    resource_access {
      id   = "4908d5b9-3fb2-4b1e-9336-1888b7937185" # Organization.Read.All
      type = "Scope"
    }
  }
}

resource "azuread_application_certificate" "m365_dsc_sp_app_cert" {
  application_object_id = azuread_application.m365_dsc_sp_app.id
  type                  = "AsymmetricX509Cert"
  encoding              = "hex"
  value                 = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_data
  end_date              = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].expires
  start_date            = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].not_before
}

resource "azuread_service_principal" "m365_dsc_sp" {
  application_id               = azuread_application.m365_dsc_sp_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_certificate" "m365_dsc_sp_cert" {
  service_principal_id = azuread_service_principal.m365_dsc_sp.id
  type                 = "AsymmetricX509Cert"
  encoding             = "hex"
  value                = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_data
  end_date             = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].expires
  start_date           = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].not_before
}
