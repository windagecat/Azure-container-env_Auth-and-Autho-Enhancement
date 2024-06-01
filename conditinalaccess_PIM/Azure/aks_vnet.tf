resource "azurerm_virtual_network" "aks" {
  name                = "vnet_${var.aks_cluster_name}"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  tags = {
     owner = var.owner
  }
}

resource "azurerm_subnet" "default" {
  name                  = "snet_${var.aks_cluster_name}"
  resource_group_name   = var.resource_group_name
  virtual_network_name  = azurerm_virtual_network.aks.name
  address_prefixes      = [var.subnet_address]
}
