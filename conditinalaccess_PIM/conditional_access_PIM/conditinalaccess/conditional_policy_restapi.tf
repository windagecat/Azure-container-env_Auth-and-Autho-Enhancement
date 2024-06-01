locals {
  policies = ["Device_compliance_policy_for_container_environments", "Sign-in_risk_policiy", "MFA_policy", "User_risk_policiy"]
}

resource "restapi_object" "conditional_access_policy" {
  count     = length(local.policies)
  #provider = restapi.restapi_headers
  create_method  = "POST"
  path = "/v1.0/identity/conditionalAccess/policies"
  data = templatefile(
      "${path.module}/json/${local.policies[count.index]}.json",
       {
        groupid = data.azuread_group.adgroup.object_id
        selfacountid = data.azuread_client_config.current.object_id
       }
  )
  destroy_method = "DELETE"
}