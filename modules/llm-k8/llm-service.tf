resource "kubernetes_service" "llm" {
  metadata {
    name      = "llm-service"
    namespace = "default"

    labels = {
      app = "llm"
    }

    annotations = {
      "service.kubernetes.io/aws-load-balancer-type"               = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"         = "internet-facing"

      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol" = "TCP"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-port"     = "50051"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval" = "10"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-timeout"  = "5"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-unhealthy-threshold" = "3"
      "service.beta.kubernetes.io/aws-load-balancer-healthcheck-healthy-threshold"   = "2"

      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "8000"
      "prometheus.io/path"   = "/metrics"
    }
  }

  spec {
    selector = {
      app = "llm"
    }

    port {
      name        = "grpc"
      port        = 50051
      target_port = 50051
      protocol    = "TCP"
    }

    port {
      name        = "metrics"
      port        = 8000
      target_port = 8000
      protocol    = "TCP"
    }

    type                    = "LoadBalancer"
    external_traffic_policy  = "Cluster"
  }
}
