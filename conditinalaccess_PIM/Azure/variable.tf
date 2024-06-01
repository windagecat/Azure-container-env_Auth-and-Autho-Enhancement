variable resource_group_name {}
variable region {}
variable vnet_name {}               
variable vnet_address_space {}      
variable subnet_name {}
variable subnet_address {}          
variable dns_service_ip {}         
#variable docker_address {}          
variable service_address {}         

variable aks_cluster_name {}
variable k8s_version {}        
variable dns_prefix {}              
variable default_node_pool_name {}  
variable enable_auto_scaling {}     
variable vm_size {}                 
variable node_count {
  type    = number
  default = 1  
}
variable max_count {
  type    = number
  default = 1
}                                   
variable min_count {
  type    = number
  default = 1
}               
variable owner {}  
variable username {}  
#variable acr_name {}

#data "azurerm_resource_group" "this" {
#  name = var.resource_group_name
#}

data "azurerm_client_config" "current" {
}