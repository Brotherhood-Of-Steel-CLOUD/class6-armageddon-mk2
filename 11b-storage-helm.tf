data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.demo.name
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.demo.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# Install EBS CSI Driver using HELM
# Resource: Helm Release 
resource "helm_release" "ebs_csi_driver" {
  depends_on = [
    aws_iam_role.ebs_csi_iam_role,
    aws_iam_openid_connect_provider.oidc_provider,
    aws_eks_cluster.demo,
    aws_eks_node_group.private-nodes,
    null_resource.update_kubeconfig
  ]

  name       = "${var.cluster_name}-aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  set = [
    # Changes based on Region - This is for us-east-1 
    # Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
    {
      name  = "image.repository"
      value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-ebs-csi-driver"
    },
    {
      name  = "controller.serviceAccount.create"
      value = "true"
    },
    {
      name  = "controller.serviceAccount.name"
      value = "ebs-csi-controller-sa"
    },
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.ebs_csi_iam_role.arn
    }
  ]
}
