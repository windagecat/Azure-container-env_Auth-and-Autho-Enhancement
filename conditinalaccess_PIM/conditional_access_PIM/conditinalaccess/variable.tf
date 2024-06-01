variable TOKEN {}

data "azuread_client_config" "current" {}
data "azuread_group" "adgroup" {
  display_name     = "condiac-pim-test"
  security_enabled = true
}