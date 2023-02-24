
variable "ARM_TENANT_ID" {
  type        = string
  description = "Tenant id in form of a GUID"
  default     = "76eaa1e5-b368-4d41-bf0a-b2078e6eb434"
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Subscription id in form of a GUID"
  default     = "ca40ebab-e130-4eb4-aa90-e52a2cc4bc9e"
}

variable "LOCATION" {
  type        = string
  description = "Region of all resources"
  default     = "westeurope"
}
