variable "AZURE_TENANT_ID" {
  type      = string
  sensitive = true
}

variable "AZURE_SUBSCRIPTION_ID" {
  type      = string
  sensitive = true
}

variable "SERVICE_PRINCIPAL_APPLICATION_ID" {
  type      = string
  sensitive = true
}

variable "SERVICE_PRINCIPAL_SECRET" {
  type      = string
  sensitive = true
}

variable "azure_tags" {
  type = object({
    managed_by = string
    purpose    = string
  })
}

variable "azure_location" { type = string }

variable "aks_version" { type = string }
variable "aks_sku_tier" { type = string }
variable "aks_cluster_name_root" { type = string }
variable "aks_vnet_address_space" { type = list(string) }
variable "aks_subnet_address_space" { type = list(string) }
variable "default_subnet_address_space" { type = list(string) }

variable "healthprobe_image" { 
  type = string
  default = "mcr.microsoft.com/dotnet/samples:aspnetapp"
}

variable "aks_default_node_pool_name" { type = string }
variable "aks_default_node_pool_count" { type = number }
variable "aks_default_node_vm_size" { type = string }
variable "aks_default_node_vm_os_disk_size_gb" { type = string }
variable "aks_application_cpu_limit" { type = string }
variable "aks_application_memory_limit" { type = string }
variable "aks_application_cpu_request" { type = string }
variable "aks_application_memory_request" { type = string }

variable "nginx_helm_release_name" { type = string }
variable "nginx_repository" { type = string }
variable "nginx_chart" { type = string }
variable "nginx_ingress_namespace" {
  type    = string
  default = "nginx_ingress"
}

variable "nginx_replica_count" { type = number }

variable "application_replica_count" { type = number }

variable "applications_namespace" {
  type    = string
  default = "applications"
}

variable "application_settings" {
  type = map(object({
    blue_stage        = string
    green_stage       = string
    green_weight      = number
    stage_one_image   = string
    stage_two_image   = string
    stage_three_image = string
  }))

  validation {
    error_message = "The \"blue_stage\" and \"green_stage\" values must be \"one\", \"two\", or \"three\" and the green_weight must be a number between 0 and 100"
    condition = alltrue(
      [
        for application in values(var.application_settings) :
        (application.blue_stage == "one" || application.blue_stage == "two" || application.blue_stage == "three") &&
        (application.green_stage == "one" || application.green_stage == "two" || application.green_stage == "three") &&
        (application.green_weight >= 0 && application.green_weight <= 100)
      ]
    )
  }
}
