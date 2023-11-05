resource "azurerm_public_ip" "ingress_nginx" {
  name                = var.aks_cluster_name_root
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  allocation_method   = "Static"
  tags                = var.azure_tags
  sku                 = "Standard"
}

output "ingress_nginx_ip_address" {
  value = azurerm_public_ip.ingress_nginx.ip_address
}

resource "kubernetes_namespace_v1" "ingress_nginx" {
  depends_on = [azurerm_public_ip.ingress_nginx]
  metadata {
    name = var.nginx_ingress_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = var.nginx_helm_release_name
  repository = var.nginx_repository
  chart      = var.nginx_chart
  namespace  = kubernetes_namespace_v1.ingress_nginx.metadata.0.name

  values = [
    templatefile("./yaml/nginx-values.yaml", {
      nginx_ingress_ip        = azurerm_public_ip.ingress_nginx.ip_address
      aks_resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
      nginx_replica_count     = var.nginx_replica_count
      }
    )
  ]
}

resource "kubernetes_namespace_v1" "applications" {
  metadata {
    name = var.applications_namespace
  }
}
