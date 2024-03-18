terraform {
  required_providers {
     azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
     }
     azuread = {
      source = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
provider "azuread" {
}
provider "kubernetes" {
  config_path    = "../../kubeconfig"
}