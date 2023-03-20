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
      id   = "498476ce-e0fe-48b0-b801-37ba7e2685c6" # Organization.Read.All
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "m365_dsc_sp" {
  application_id               = azuread_application.m365_dsc_sp_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}