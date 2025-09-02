output "eks_cluster_info" {
  value = {
    name        = aws_eks_cluster.demo.name
    endpoint    = aws_eks_cluster.demo.endpoint
    arn         = aws_eks_cluster.demo.arn
    id          = aws_eks_cluster.demo.id
    description = "EKS cluster info"
  }
}


output "eks_node_group_summary" {
  value = format("Node group '%s' runs %s instance(s) of type %s",
    aws_eks_node_group.private-nodes.node_group_name,
    aws_eks_node_group.private-nodes.scaling_config[0].desired_size,
    join(", ", aws_eks_node_group.private-nodes.instance_types)
  )
  description = "Summary of EKS node group configuration"
}


# Output: AWS IAM Open ID Connect Provider ARN
output "openid_connect_provider" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value = {
    arn = aws_iam_openid_connect_provider.oidc_provider.arn
    url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
  }
}




