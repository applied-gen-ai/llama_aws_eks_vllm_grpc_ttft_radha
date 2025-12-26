module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
}

module "llm_k8s" {
  source = "./modules/llm-k8s"

  image = "radha2990/stablelm-api-vllm-grpc:latest"
}

