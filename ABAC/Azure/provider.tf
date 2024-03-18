# provider
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
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "aksRBACtest"
    storage_account_name = "<ストレージアカウント名>"
    container_name       = "azure-tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
provider "azuread" {
}

# Resource group
#resource "azurerm_resource_group" "this" {
#  name     = var.resource_group_name
#  location = var.region
#  tags = {
#     owner = var.owner
#  }
#}
