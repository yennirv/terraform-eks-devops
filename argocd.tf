resource "helm_release" "argocd" {
      namespace        = "argocd"
      create_namespace = true      
      name       = "argocd"
      repository = "https://argoproj.github.io/argo-helm" 
      chart      = "argo-cd"
      set {
        name  = "server.service.type"
        value = "LoadBalancer"
      }
      depends_on = [ aws_eks_addon.addons ]
}

resource "null_resource" "get_argocd_password" {
  provisioner "local-exec" {
    command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d >> argocd_password.txt"
    interpreter = ["bash", "-c"]
  }
}

data "local_file" "argocd_password_file" {
  depends_on = [null_resource.get_argocd_password]
  filename   = "${path.module}/argocd_password.txt"
}

output "argocd_password" {
  value = "${data.local_file.argocd_password_file.content}"
}
