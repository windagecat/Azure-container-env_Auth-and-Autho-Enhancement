terraform {
  required_providers {
     azuread = {
      source = "hashicorp/azuread"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azuread" {
  client_id     = var.ARM_CLIENT_ID
  client_secret = var.ARM_CLIENT_SECRET
  tenant_id     = var.ARM_TENANT_ID
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}