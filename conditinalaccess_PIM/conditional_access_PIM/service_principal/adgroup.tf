locals {
  group = "condiac-pim-test"
}



resource "azuread_group" "main" {
  display_name     = "${local.group}"
  security_enabled = true
}
