resource "kubernetes_horizontal_pod_autoscaler_v2" "llm" {
  metadata {
    name      = "llm-hpa"
    namespace = "default"

    labels = {
      app = "llm"
    }
  }

  spec {
    min_replicas = 1
    max_replicas = 3

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.llm.metadata[0].name
    }

    metric {
      type = "Pods"

      pods {
        metric {
          name = "llm_request_queue_length"
        }

        target {
          type          = "AverageValue"
          average_value = "1"
        }
      }
    }

    behavior {
      scale_up {
        stabilization_window_seconds = 15
        select_policy                = "Max"

        policy {
          type           = "Percent"
          value          = 100
          period_seconds = 30
        }

        policy {
          type           = "Pods"
          value          = 2
          period_seconds = 30
        }
      }

      scale_down {
        stabilization_window_seconds = 30
        select_policy                = "Max"

        policy {
          type           = "Percent"
          value          = 50
          period_seconds = 60
        }
      }
    }
  }
}
