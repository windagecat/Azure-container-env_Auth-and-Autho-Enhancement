locals {
  domain_name = data.azuread_domains.aad-domain.domains.0.domain_name
  teams       = ["k8sdevelopA", "k8sdevelopB","k8sroleassign"]
  users       = ["k8sdeveloper1", "k8sdeveloper2", "k8sroleassigner1"]
}

resource "random_password" "password" {
  length           = 15
  special          = true
  lifecycle {
    ignore_changes = [
      length,
      special,
    ]
  }
}

resource "random_id" "suffix" {
  byte_length = 2
  lifecycle {
    ignore_changes = [
      byte_length,
    ]
  }
}

resource "azuread_user" "k8s_users" {
  count               = length(local.users)
  user_principal_name = format(
    "%s-%d@%s",
    local.users[count.index],
    random_id.suffix.dec,
    local.domain_name
  )
  display_name        = local.users[count.index]
  password            = random_password.password.result
}

resource "azuread_group" "k8s_groups" {
  count           = length(local.teams)
  display_name     = local.teams[count.index]
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  members = [
    azuread_user.k8s_users[count.index].object_id,
  ]
}

output "k8suserpassword" {
  description = "k8s users password"
  value       = random_password.password.result
  sensitive = true
}


resource "azurerm_role_assignment" "aks_get-credentials_role" { 
  count                            = length(azuread_group.k8s_groups)
  principal_id                     = azuread_group.k8s_groups[count.index].object_id
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  scope                            = "${data.azurerm_kubernetes_cluster.aks.id}"
  skip_service_principal_aad_check = false
}
