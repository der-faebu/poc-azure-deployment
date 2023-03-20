## rg
resource "azurerm_resource_group" "deployment" {
  location = var.resource_group_location_short
  name     = var.resource_group_name
}