terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  storage_use_azuread = true
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.region
  tags = {
     owner = var.owner
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled = false
  default_to_oauth_authentication = true

  tags = {
    owner = var.owner
  }
}

resource "azurerm_storage_container" "tfstate" {
  count                 = length(local.storage_containers)
  name                  = local.storage_containers[count.index]
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_role_assignment" "tfstate" { 
  principal_id                     = data.azurerm_client_config.current.object_id
  role_definition_name             = "Storage Blob Data Contributor"
  scope                            = azurerm_storage_account.tfstate.id
  skip_service_principal_aad_check = false
  condition                        = <<-EOT
  (
   (
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.List'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.Tier'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'})
    AND
    !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'})
   )
   OR 
   (
    @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringLike '*tfstate'
   )
  )
  EOT
  condition_version                = "2.0"
}

output "tfstate_storage_account" {
 value = azurerm_storage_account.tfstate.name
}

output "azurerm_resource_group" {
 value = azurerm_resource_group.this.name
}