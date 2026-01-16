output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

/*output "alb_controller_serviceaccount_role_arn" {
  description = "IAM Role ARN for AWS Load Balancer Controller Service Account"
  value       = aws_iam_role.alb_controller_role.arn
}*/
