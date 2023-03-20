# # resource "azurerm_key_vault_certificate" "m365_dsc_sp_cert" {
# #   name         = "m365-dsc-sp-cert"
# #   key_vault_id = azurerm_key_vault.az_managed_identity_key_vault.id

# #   certificate_policy {
# #     issuer_parameters {
# #       name = "Self"
# #     }

# #     key_properties {
# #       exportable = true
# #       key_size   = 2048
# #       key_type   = "RSA"
# #       reuse_key  = true
# #     }

# #     lifetime_action {
# #       action {
# #         action_type = "AutoRenew"
# #       }

# #       trigger {
# #         days_before_expiry = 30
# #       }
# #     }
# #     secret_properties {
# #       content_type = "application/x-pkcs12"
# #     }

# #     x509_certificate_properties {
# #       # Server Authentication = 1.3.6.1.5.5.7.3.1
# #       # Client Authentication = 1.3.6.1.5.5.7.3.2
# #       extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

# #       key_usage = [
# #         "cRLSign",
# #         "dataEncipherment",
# #         "digitalSignature",
# #         "keyAgreement",
# #         "keyCertSign",
# #         "keyEncipherment",
# #       ]

# #       # subject_alternative_names {
# #       #   dns_names = ["internal.contoso.com", "domain.hello.world"]
# #       # }

# #       subject            = "CN=perigoncloud-cust1.ch"
# #       validity_in_months = 12
# #     }
# #   }

  
# # }


# # resource "azuread_application_certificate" "m365_dsc_sp_app_cert" {
# #   application_object_id = azuread_application.m365_dsc_sp_app.id
# #   type                  = "AsymmetricX509Cert"
# #   encoding              = "hex"
# #   value                 = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_data
# #   end_date              = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].expires
# #   start_date            = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].not_before
# # }

# # resource "azuread_service_principal_certificate" "m365_dsc_sp_cert" {
# #   service_principal_id = azuread_service_principal.m365_dsc_sp.id
# #   type                 = "AsymmetricX509Cert"
# #   encoding             = "hex"
# #   value                = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_data
# #   end_date             = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].expires
# #   start_date           = azurerm_key_vault_certificate.m365_dsc_sp_cert.certificate_attribute[0].not_before
# # }

# resource "azurerm_key_vault_certificate" "key_vault_certificate" {
#   name         = var.managed_identity_cert
#   key_vault_id = key_vault.id

#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }

#     key_properties {
#       exportable = true
#       key_size   = 2048
#       key_type   = "RSA"
#       reuse_key  = true
#     }

#     lifetime_action {
#       action {
#         action_type = "AutoRenew"
#       }

#       trigger {
#         days_before_expiry = 30
#       }
#     }
#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }

#     x509_certificate_properties {
#       extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

#       key_usage = [
#         "cRLSign",
#         "dataEncipherment",
#         "digitalSignature",
#         "keyAgreement",
#         "keyCertSign",
#         "keyEncipherment",
#       ]

#       subject            = "CN=${var.customer_name}"
#       validity_in_months = 12
#     }
#   }
# }
