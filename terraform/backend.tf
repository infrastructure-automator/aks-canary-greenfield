terraform {
  required_version = "~>1.6.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.78.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.11.0"
    }
  }

  backend "local" {
    path = "./statefile/aks-blue-green.base-infrastructure.tfstate"
  }
}

provider "azurerm" {
  tenant_id       = var.AZURE_TENANT_ID
  subscription_id = var.AZURE_SUBSCRIPTION_ID
  client_id       = var.SERVICE_PRINCIPAL_APPLICATION_ID
  client_secret   = var.SERVICE_PRINCIPAL_SECRET

  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
    password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

data "azurerm_client_config" "current" {}
