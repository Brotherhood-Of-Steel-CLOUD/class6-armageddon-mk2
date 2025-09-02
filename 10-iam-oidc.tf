
# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  #client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer

  tags = {
    Name = "${var.cluster_name}-eks-irsa"
  }
}

locals {
  split_from_arn = split("oidc-provider/", aws_iam_openid_connect_provider.oidc_provider.arn)
  extracted      = element(local.split_from_arn, 1)
}
