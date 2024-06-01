terraform {
  required_providers {
     azuread = {
      source = "hashicorp/azuread"
      version = "~>2.0"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "~>1.19.0"
    }
  }
}

provider "azuread" {
}

provider "restapi" {
  uri                  = "https://graph.microsoft.com"
  write_returns_object = true
  debug                = true

  headers = {
    "Authorization" = "Bearer ${var.TOKEN}",
    "Content-Type" = "application/json"
  }

  create_method  = "POST"
  destroy_method = "DELETE"
}
