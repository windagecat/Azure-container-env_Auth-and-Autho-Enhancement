variable resource_group_name {}
variable recipients {
  type = list
}
variable ARM_CLIENT_ID {}
variable ARM_CLIENT_SECRET {}
variable ARM_TENANT_ID {}

data "azuread_group" "adgroup" {
  display_name     = "condiac-pim-test"
  security_enabled = true
}

#data "azuread_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}