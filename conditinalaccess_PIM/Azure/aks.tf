# AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name
  local_account_disabled = true
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version
  tags = {
    owner = var.owner
  }

  azure_active_directory_role_based_access_control {
    managed = true
    azure_rbac_enabled = true

  }

  default_node_pool {
    name                = "defaultpool"
    vm_size             = var.vm_size
    node_count          = var.node_count
    vnet_subnet_id      = azurerm_subnet.default.id
    type                = "VirtualMachineScaleSets"
    tags = {
     owner = var.owner
    }  

    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
  }

  identity {
    type = "SystemAssigned"
  }

  #service_principal {
  #  client_id     = var.ARM_CLIENT_ID
  #  client_secret = var.ARM_CLIENT_SECRET
  #}

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = var.dns_service_ip
    #docker_bridge_cidr = var.docker_address
    service_cidr       = var.service_address
    load_balancer_sku  = "standard"
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = file(".key_pair/ssh_key.id_rsa.pub")
    }
  }
}

resource "azurerm_role_assignment" "aks-RBAC-clusteradmin" { 
  principal_id                     = data.azurerm_client_config.current.object_id
  role_definition_name             = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                            = azurerm_kubernetes_cluster.aks.id
  #skip_service_principal_aad_check = false
}


resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "az aks get-credentials --name ${azurerm_kubernetes_cluster.aks.name} --resource-group ${var.resource_group_name} -f ../kubeconfig --overwrite-existing"
  }
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = var.resource_group_name
}
