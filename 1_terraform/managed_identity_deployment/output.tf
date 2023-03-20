output "APPLICATION_ID" {
  value = azuread_application.m365_dsc_sp_app.id
}
output "APPLICATION_NAME" {
  value = azuread_application.m365_dsc_sp_app.display_name
}
output "CUSTOMER_ID" {
  value = var.customer_id
}
output "CUSTOMER_NAME" {
  value = var.customer_name
}
output "TENANT_ID"{
  value = var.tenant_id
}
output "SUBSCRIPTION_ID"{
  value = var.subscription_id
}
