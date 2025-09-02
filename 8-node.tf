resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# Use Amazon VPC CNI Plugin rather than Flannel or similar
# this is the IAM policy for podes to use native VPC network rather than virtual pod network
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

# EKS Registry IAM policy
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}




##################

# Node group which is an ASG(s) managed by EKS service
resource "aws_eks_node_group" "private-nodes" {

  # attach to control plane (EKS service)
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "${var.cluster_name}-private-nodes"

  # attach IAM role (with the 3 above policies: EKSWorkerNode, EKS_CNI, EC2ContainerRegistryReadOnly )
  node_role_arn = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id
  ]

  # standard EC2 instances
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 0
  }

  # how many nodes can be down during OS/K8s upgrades
  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  # current node size and desired size may conflict so have terraform ignore these on all "terraform apply"
  # after the inital build to avoid unexpected chaneges
  # look in terraform documentation to understand this meta-argument
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

