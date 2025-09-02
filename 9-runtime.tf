# Connect to cluster (add proper context to kubeconfig)

resource "null_resource" "update_kubeconfig" {
  count = var.enable_kubeconfig ? 1 : 0

  provisioner "local-exec" {
    #interpreter=["bash", "-c"]
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.demo.name}"
  }

  depends_on = [aws_eks_cluster.demo]
}

