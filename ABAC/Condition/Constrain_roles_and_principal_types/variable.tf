variable resource_group_name {}
variable aks_cluster_name  {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azuread_domains" "aad-domain" {
  only_initial = true
}