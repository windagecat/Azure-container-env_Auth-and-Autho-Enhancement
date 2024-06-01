resource "random_string" "random" {
  length  = 4
  special = false
  min_lower = 1
  min_numeric = 1
  min_upper = 1
  keepers = {
    group_name = "sp"
  }
}

resource "azuread_application" "sp" {
  display_name = "sp-${random_string.random.id}"
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Application.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Policy.Read.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Policy.ReadWrite.ConditionalAccess"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup"]
      type = "Role"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["RoleManagementPolicy.ReadWrite.AzureADGroup"]
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.sp.client_id
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.object_id
}

output "service_principal_tenantid" {
 value = azuread_service_principal.sp.application_tenant_id 
}

output "service_principal_clientid" {
 value = azuread_application.sp.client_id
}

output "service_principal_password" {
 value = azuread_service_principal_password.sp.value
 sensitive = true
}