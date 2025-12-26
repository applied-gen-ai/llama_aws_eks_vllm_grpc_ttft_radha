resource "kubernetes_deployment" "llm" {
  metadata {
    name      = "llm-deployment"
    namespace = "default"

    labels = {
      app = "llm"
    }

    annotations = {
      rollme = "stableai-v1.14"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "llm"
      }
    }

    template {
      metadata {
        labels = {
          app = "llm"
        }
      }

      spec {
        toleration {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        container {
          name  = "llm"
          image = var.image

          port {
            name           = "grpc"
            container_port = 50051
          }

          port {
            name           = "metrics"
            container_port = 8000
          }

          # ---- Probes ----
          startup_probe {
            tcp_socket {
              port = 50051
            }
            period_seconds    = 5
            failure_threshold = 120
          }

          readiness_probe {
            tcp_socket {
              port = 50051
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            failure_threshold     = 12
          }

          liveness_probe {
            tcp_socket {
              port = 50051
            }
            initial_delay_seconds = 120
            period_seconds        = 10
            failure_threshold     = 3
          }

          # ---- Env ----
          env {
            name  = "GRPC_PORT"
            value = "50051"
          }

          env {
            name  = "METRICS_PORT"
            value = "8000"
          }

          env {
            name  = "MAX_INFLIGHT"
            value = "384"
          }

          # ---- Resources ----
          resources {
            requests = {
              memory = "16Gi"
              cpu    = "4"
            }
            limits = {
              "nvidia.com/gpu" = "1"
              memory            = "24Gi"
              cpu               = "6"
            }
          }
        }
      }
    }
  }
}
