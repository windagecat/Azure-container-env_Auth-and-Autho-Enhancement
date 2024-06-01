locals {
  pimgroup = ["k8sadmin", "k8scontributor", "armadmin", "armcontributor"]
}

resource "random_string" "random" {
  length  = 4
  special = false
  min_lower = 1
  min_numeric = 1
  min_upper = 1
  keepers = {
    group_name = data.azuread_group.adgroup.display_name
  }
}

resource "azuread_group" "pimgroups" {
  count            = length(local.pimgroup)
  display_name     = "${local.pimgroup[count.index]}-${random_string.random.id}"
  security_enabled = true
}

resource "azuread_privileged_access_group_eligibility_schedule" "pim" {
  count           = length(local.pimgroup)
  group_id        = azuread_group.pimgroups[count.index].object_id
  principal_id    = data.azuread_group.adgroup.object_id
  assignment_type = "member"
  duration        = "P365D"
  #justification   = "as requested"
}

resource "azuread_group_role_management_policy" "pim" {
  depends_on = [azuread_privileged_access_group_eligibility_schedule.pim]
  count    = length(local.pimgroup)
  group_id = azuread_group.pimgroups[count.index].object_id
  role_id  = "member"
  
  activation_rules {
    maximum_duration = "PT8H"
    require_approval = true
    approval_stage {
      primary_approver {
        object_id = data.azurerm_client_config.current.object_id
        type      = "singleUser"
      }
    }
    require_multifactor_authentication = true
    require_justification = true
  }
  active_assignment_rules {
    expiration_required = true
    expire_after = "P30D"
    require_justification = true
  }

  eligible_assignment_rules {
    expiration_required = true
    expire_after = "P365D"
  }

  notification_rules {
    eligible_assignments {
      admin_notifications {
        notification_level = "All"
        default_recipients = false
        additional_recipients = var.recipients
      }
    }
    active_assignments {
      admin_notifications {
        notification_level = "All"
        default_recipients = false
        additional_recipients = var.recipients
      }
    }
    eligible_activations {
      admin_notifications {
        notification_level = "All"
        default_recipients = false
        additional_recipients = var.recipients
      }
    }
  }
}