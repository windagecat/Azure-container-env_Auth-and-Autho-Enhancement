resource "random_string" "random" {
  length  = 4
  special = false
  min_lower = 1
  min_numeric = 1
  min_upper = 1
  keepers = {
    acr_name = var.acr_name
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${random_string.random.keepers.acr_name}${random_string.random.id}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
}
resource "azurerm_role_assignment" "acr-aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}