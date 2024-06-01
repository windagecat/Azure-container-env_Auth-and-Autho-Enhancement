resource "azurerm_role_definition" "k8scontributor" {
  name        = "Azure Kubernetes Service RBAC Cluster Contributor"
  scope       = data.azurerm_subscription.current.id
  description = "Role for k8scontributor"

  permissions {
    actions          = []
    not_actions      = []
    data_actions     = [
      "Microsoft.ContainerService/managedClusters/*"
    ]
    not_data_actions   = [
      "Microsoft.ContainerService/managedClusters/apis/rbac.authorization.k8s.io/*",
      "Microsoft.ContainerService/managedClusters/rbac.authorization.k8s.io/*"
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_assignment" "k8sadmin" { 
  principal_id                     = azuread_group.pimgroups[0].object_id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                            = data.azurerm_resource_group.this.id
}
resource "azurerm_role_assignment" "k8scontributor" { 
  principal_id                     = azuread_group.pimgroups[1].object_id
  role_definition_name             = azurerm_role_definition.k8scontributor.name
  scope                            = data.azurerm_resource_group.this.id
}
resource "azurerm_role_assignment" "armowner" { 
  principal_id                     = azuread_group.pimgroups[2].object_id
  role_definition_name             = "Owner"
  scope                            = data.azurerm_resource_group.this.id
}
resource "azurerm_role_assignment" "armcontributor" { 
  principal_id                     = azuread_group.pimgroups[3].object_id
  role_definition_name             = "Contributor"
  scope                            = data.azurerm_resource_group.this.id
}