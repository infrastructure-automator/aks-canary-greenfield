############################
## Blue Routing (Primary) ##
############################

resource "kubernetes_service_v1" "application_service_blue" {
  for_each = var.application_settings

  metadata {
    name      = "${each.key}-blue-service"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.key}"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      "application" = "${each.key}-${each.value.blue_stage}"
    }

    port {
      protocol    = "TCP"
      name        = "http"
      port        = "80"
      target_port = "8080"
    }
  }
}

resource "kubernetes_ingress_v1" "application_ingress_blue" {
  for_each = var.application_settings

  metadata {
    name      = "${each.key}-blue-ingress"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.key}"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/use-regex"             = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"        = "/$2"
      "nginx.ingress.kubernetes.io/configuration-snippet" = "sub_filter 'href=\"/' 'href=\"/${each.key}/'; sub_filter 'src=\"/' 'src=\"/${each.key}/'; sub_filter_once off;"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {

        path {
          path = "/${each.key}(/|$)(.*)"
          backend {

            service {
              name = "${each.key}-blue-service"

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

############################
## Green Routing (Canary) ##
############################

resource "kubernetes_service_v1" "application_servigreen" {
  for_each = var.application_settings

  metadata {
    name      = "${each.key}-green-service"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.key}"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      "application" = "${each.key}-${each.value.green_stage}"
    }

    port {
      protocol    = "TCP"
      name        = "http"
      port        = "80"
      target_port = "8080"
    }
  }
}

resource "kubernetes_ingress_v1" "application_ingress_green" {
  for_each = var.application_settings

  metadata {
    name      = "${each.key}-green-ingress"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "${each.key}"
    }
    annotations = {
      "nginx.ingress.kubernetes.io/use-regex"             = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"        = "/$2"
      "nginx.ingress.kubernetes.io/configuration-snippet" = "sub_filter 'href=\"/' 'href=\"/${each.key}/'; sub_filter 'src=\"/' 'src=\"/${each.key}/'; sub_filter_once off;"
      "nginx.ingress.kubernetes.io/canary"                = "true"
      "nginx.ingress.kubernetes.io/canary-weight"         = "${each.value.green_weight}"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {

      http {

        path {
          path = "/${each.key}(/|$)(.*)"

          backend {

            service {
              name = "${each.key}-green-service"

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

###################
## Frontend URLs ##
###################

output "Frontend_URLs" {
  value = [for app_key, app_value in var.application_settings : 
    "http://${azurerm_public_ip.ingress_nginx.ip_address}/${app_key}/" 
  ]
}