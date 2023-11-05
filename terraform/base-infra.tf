resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.aks_cluster_name_root}-${random_string.suffix.result}"
  location = var.azure_location
  tags     = var.azure_tags
}

output "aks_resource_group_name" {
  value = azurerm_resource_group.aks.name
}

resource "azurerm_virtual_network" "aks" {
  name                = "${var.aks_cluster_name_root}-vnet-${azurerm_resource_group.aks.location}"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  tags                = var.azure_tags
  address_space       = var.aks_vnet_address_space
}

resource "azurerm_subnet" "default" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.default_subnet_address_space
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.aks_cluster_name_root}-subnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_subnet_address_space
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "${var.aks_cluster_name_root}-${random_string.suffix.result}"
  location                = azurerm_resource_group.aks.location
  resource_group_name     = azurerm_resource_group.aks.name
  node_resource_group     = "${var.aks_cluster_name_root}-${random_string.suffix.result}-nodes"
  dns_prefix              = var.aks_cluster_name_root
  kubernetes_version      = var.aks_version
  private_cluster_enabled = false
  sku_tier                = var.aks_sku_tier

  default_node_pool {
    name            = var.aks_default_node_pool_name
    node_count      = var.aks_default_node_pool_count
    vm_size         = var.aks_default_node_vm_size
    os_disk_size_gb = var.aks_default_node_vm_os_disk_size_gb
    vnet_subnet_id  = azurerm_subnet.aks.id
  }

  role_based_access_control_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.azure_tags
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

data "azurerm_resource_group" "aks_node_resource_group" {
  name = azurerm_kubernetes_cluster.aks.node_resource_group
}
