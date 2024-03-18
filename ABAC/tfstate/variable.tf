variable region {}                  
variable resource_group_name {}     
variable owner {}  
#data "azurerm_resource_group" "this" {
#  name = var.resource_group_name
#}

data "azurerm_client_config" "current" {
}