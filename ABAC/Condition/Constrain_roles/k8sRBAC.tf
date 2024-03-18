resource "azurerm_role_definition" "k8sdeveloper" {
  name        = "k8sdeveloper"
  scope       = data.azurerm_subscription.current.id
  description = "Role for k8sdeveloper"

  permissions {
    actions          = []
    not_actions      = []
    data_actions     = [
      "Microsoft.ContainerService/managedClusters/services/read",
      "Microsoft.ContainerService/managedClusters/apps/deployments/read",
      "Microsoft.ContainerService/managedClusters/pods/read",
      "Microsoft.ContainerService/managedClusters/logs/read"
    ]
    not_data_actions   = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_definition" "k8sroleassigner" {
  name        = "k8sroleassigner"
  scope       = data.azurerm_subscription.current.id
  description = "Role for k8sroleassigner"

  permissions {
    actions          = [
      "Microsoft.Authorization/roleAssignments/*"
    ]
    not_actions      = []
    data_actions     = []
    not_data_actions   = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_assignment" "k8sroleassigner" { 
  count                            = length(kubernetes_namespace.ns)
  principal_id                     = azuread_group.k8s_groups[2].object_id
  role_definition_id               = azurerm_role_definition.k8sroleassigner.role_definition_resource_id
  scope                            = "${data.azurerm_kubernetes_cluster.aks.id}/namespaces/${kubernetes_namespace.ns[count.index].metadata[0].name}"
  skip_service_principal_aad_check = false
  condition                        = <<-EOT
  ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${azurerm_role_definition.k8sdeveloper.role_definition_id}})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${azurerm_role_definition.k8sdeveloper.role_definition_id}}))
  EOT
  condition_version                = "2.0"
}

