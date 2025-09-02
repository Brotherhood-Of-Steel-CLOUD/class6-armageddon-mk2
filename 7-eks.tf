
# IAM Role identity for cluster itself
resource "aws_iam_role" "demo" {
  name = "${var.cluster_name}-eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# legacy EKS IAM Permissons (overly broad as it includes many CLB permissons)
# [ "ec2:DescribeInstances", "ec2DescribeNetworkInterfaces", "ec2:DescribeVpcs", "ec2:DescribeDhcpOptions", "kms:DescribeKey" ]
# https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}


# EKS Cluster service
resource "aws_eks_cluster" "demo" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo.arn


  # Network configurations for cluster
  vpc_config {

    # for now, we have a public endpoint for kubectl as we dont have a VPN or similar
    # these are set by default
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private_zone1.id,
      aws_subnet.private_zone2.id,
      aws_subnet.public_zone1.id,
      aws_subnet.public_zone2.id
    ]
  }

  # ensure latest access config policy is API and bpptstrap access config
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}