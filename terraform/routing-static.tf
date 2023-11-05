############################
## Application Deployment ##
############################

resource "kubernetes_deployment_v1" "application_deployments" {
  for_each = {
    for entry in local.application_specific_variables : "${entry.application_subdomain}-${entry.stage_name}" => entry
    if entry.create_application_stage == "Deployed"
  }

  metadata {
    name      = "${each.value.application_subdomain}-${each.value.stage_name}-deployment"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
    }
  }

  spec {
    replicas = var.application_replica_count

    selector {
      match_labels = {
        "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
      }
    }

    template {
      metadata {
        labels = {
          "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
        }
      }

      spec {
        container {
          image = each.value.image
          name  = each.value.application_subdomain

          resources {
            limits = {
              cpu    = var.aks_application_cpu_limit
              memory = var.aks_application_memory_limit
            }
            requests = {
              cpu    = var.aks_application_cpu_request
              memory = var.aks_application_memory_request
            }
          }

          port {
            name           = "http"
            container_port = "8080"
            protocol       = "TCP"
          }
        }
      }
    }
  }
}

#########################
## Application Service ##
#########################

resource "kubernetes_service_v1" "application_services" {
  for_each = {
    for entry in local.application_specific_variables : "${entry.application_subdomain}-${entry.stage_name}" => entry
    if entry.create_application_stage == "Deployed"
  }

  metadata {
    name      = "${each.value.application_subdomain}-${each.value.stage_name}-service"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
    }

    port {
      protocol    = "TCP"
      name        = "http"
      port        = "80"
      target_port = "8080"
    }
  }
}

#########################
## Application Ingress ##
#########################

resource "kubernetes_ingress_v1" "application_ingress" {
  for_each = {
    for entry in local.application_specific_variables : "${entry.application_subdomain}-${entry.stage_name}" => entry
  }

  metadata {
    name      = "${each.value.application_subdomain}-${each.value.stage_name}-ingress"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.value.application_subdomain}-${each.value.stage_name}"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/use-regex"             = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"        = "/$2"
      "nginx.ingress.kubernetes.io/configuration-snippet" = "sub_filter 'href=\"/' 'href=\"/${each.value.application_subdomain}-${each.value.stage_name}/'; sub_filter 'src=\"/' 'src=\"/${each.value.application_subdomain}-${each.value.stage_name}/'; sub_filter_once off;"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {

      http {

        path {
          path      = "/${each.value.application_subdomain}-${each.value.stage_name}(/|$)(.*)"
          backend {

            service {
              name = "${each.value.application_subdomain}-${each.value.stage_name}-service"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

##################
## Backend URLs ##
##################

output "Backend_URLs" {
  value = [for entry in local.application_specific_variables : 
    "${entry.create_application_stage}: http://${azurerm_public_ip.ingress_nginx.ip_address}/${entry.application_subdomain}-${entry.stage_name}/"]
}
