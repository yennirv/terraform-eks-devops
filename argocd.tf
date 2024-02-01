resource "helm_release" "argocd" {
      namespace        = "argocd"
      create_namespace = true      
      name       = "argocd"
      repository = "https://argoproj.github.io/argo-helm" 
      chart      = "argo-cd"
      depends_on = [ aws_eks_addon.addons ]
}


