###########################
## Application Namespace ##
###########################

resource "kubernetes_config_map" "healthprobe" {
  metadata {
    name = "healthprobe-config"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "healthprobe"
    }
  }

  data = {
    "index.html" = <<EOF
<html>
    <head>
        <title>Healthy</title>
    </head>
    <body>
        <h1 style="color: #000000">Healthy</h1>
    </body>
</html>
EOF
  }
}

resource "kubernetes_deployment_v1" "healthprobe" {
  metadata {
    name = "healthprobe-deployment"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "healthprobe"
    }
  }

  spec {
    replicas = var.application_replica_count
    selector {
      match_labels = {
        "application" = "healthprobe-deployment"
      }
    }

    template {
      metadata {
        labels = {
          "application" = "healthprobe-deployment"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name = "healthprobe"

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
            container_port = "80"
            protocol       = "TCP"
          }

          volume_mount {
            name = "healthprobe-config"
            mount_path = "/usr/share/nginx/html"
          }
        }

        volume {
          name = "healthprobe-config"
          config_map {
            name = "healthprobe-config"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "healthprobe" {
  metadata {
    name = "healthprobe-service"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "healthprobe"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      "application" = "healthprobe-deployment"
    }

    port {
      protocol    = "TCP"
      name        = "http"
      port        = "80"
      target_port = "80"
    }
  }
}

resource "kubernetes_ingress_v1" "healthprobe" {
  metadata {
    name = "healthprobe"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata.0.name
    labels = {
      "application" = "healthprobe"
    }

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {

      http {

        path {
          path = "/healthprobe/"

          backend {

            service {
              name = "healthprobe-service"

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

output "healthprobe_URL" {
  value = "http://${azurerm_public_ip.ingress_nginx.ip_address}/healthprobe/" 
}