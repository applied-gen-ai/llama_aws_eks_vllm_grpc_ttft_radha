# =======================================================
#  EKS Cluster + GPU Node Group + IAM (INFRA ONLY)
# =======================================================

# -----------------------------
# EKS Cluster
# -----------------------------
resource "aws_eks_cluster" "this" {
  name     = "llm-eks-cluster"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# -----------------------------
# GPU Node Group
# -----------------------------
resource "aws_eks_node_group" "gpu" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "gpu-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  instance_types = ["g5.2xlarge"]
  ami_type       = "AL2023_x86_64_NVIDIA"
  capacity_type  = "ON_DEMAND"
  disk_size      = 100

  scaling_config {
    min_size     = 1
    desired_size = 1
    max_size     = 3
  }
}

# -----------------------------
# IAM Role - Cluster
# -----------------------------
resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role-llm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# -----------------------------
# IAM Role - Nodes
# -----------------------------
resource "aws_iam_role" "node" {
  name = "eks-node-role-llm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}