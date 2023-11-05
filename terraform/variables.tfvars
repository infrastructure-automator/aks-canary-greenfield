aks_cluster_name_root = "scott-aks-bgtest"
azure_location        = "eastus"

azure_tags = {
  managed_by = "Terraform"
  purpose    = "Testing Blue/Green and Canary deployments"
}

applications_namespace = "applications"

aks_vnet_address_space       = ["10.55.128.0/22"]
default_subnet_address_space = ["10.55.128.0/24"]
aks_subnet_address_space     = ["10.55.130.0/24"]

aks_version                         = "1.27.3"
aks_sku_tier                        = "Standard"
aks_default_node_pool_name          = "system"
aks_default_node_pool_count         = 5
aks_default_node_vm_size            = "Standard_B2s"
aks_default_node_vm_os_disk_size_gb = "128"
aks_application_cpu_limit           = "200m"
aks_application_memory_limit        = "128Mi"
aks_application_cpu_request         = "100m"
aks_application_memory_request      = "64Mi"

nginx_helm_release_name   = "ingress-nginx"
nginx_repository          = "https://kubernetes.github.io/ingress-nginx"
nginx_chart               = "ingress-nginx"
nginx_ingress_namespace   = "ingress-nginx"
nginx_replica_count       = 1
application_replica_count = 1
