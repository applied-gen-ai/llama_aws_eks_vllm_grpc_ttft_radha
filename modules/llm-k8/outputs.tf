output "llm_service_dns" {
  value = kubernetes_service.llm.status[0].load_balancer[0].ingress[0].hostname
}

output "llm_target" {
  value = "${kubernetes_service.llm.status[0].load_balancer[0].ingress[0].hostname}:50051"
}
