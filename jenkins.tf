resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "jenkins"
  create_namespace = true  
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.0.10"
  depends_on = [aws_eks_addon.addons]
}


