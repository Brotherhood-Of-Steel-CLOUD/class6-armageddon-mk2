  # Skeleton only: networking, node groups, IAM roles, etc. will be added in later steps.
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::536697248519:role/AWStask2KubeRole" # Replace with your IAM role ARN

  vpc_config {
    subnet_ids = module.vpc.public_subnets
    endpoint_public_access = true
    endpoint_private_access = false
  }

  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
  }

  # Add additional required arguments as needed
}

# Skeleton only: networking, node groups, IAM roles, etc. will be added in later steps.
