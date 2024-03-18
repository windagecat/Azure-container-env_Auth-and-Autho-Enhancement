# parameter
resource_group_name     = "aksRBACtest"      //resource group name
vnet_name               = "vnet_aks01"    // vNet name
vnet_address_space      = "10.0.0.0/16"         // vnet address space
subnet_name             = "snet_aks01"    // subnet name 
subnet_address          = "10.0.1.0/24"         // subnet address
dns_service_ip          = "10.1.0.10"           // dns service ip
# docker_address          = "172.17.0.1/16"       // docker address
service_address         = "10.1.0.0/24"         // service address

aks_cluster_name        = "aks_cp01"      // aks cluster name
k8s_version             = "1.27"                // k8s version
dns_prefix              = "cpcluster01"         // dns prefix
default_node_pool_name  = "cpdemo01"            // default node pool name
enable_auto_scaling     = "true"                // enable auto scaling
vm_size                 = "Standard_B2s"      // vm size
node_count              = 1                   // node count
max_count               = 3                   // max count 
min_count               = 1                   // min count
owner                   = "testuser"               // owner tag name
username                = "aksuser"           //ssh user name for aks node 
acr_name                = "acrforaks"           //acr name