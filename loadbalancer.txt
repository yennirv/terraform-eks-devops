# Recursos Logicos del Cluster

resource "kubectl_manifest" "serviceaccount_nlb" {
    yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    rolearn: ${ aws_iam_role.node_instance_role.arn }
YAML
}  

# Chart de helm 

resource "helm_release" "load-balancer-crds" {
      name       = "load-balancer-crds"
      repository = "./helm/nginx-ingress"
      chart      = "./helm/load-balancer-crds"
      version    = "v0.1.1"
}

resource "helm_release" "aws-load-balancer-controller" {
  namespace        = "kube-system"
  create_namespace = false

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
#  version    = "v0.13.1"

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [helm_release.load-balancer-crds]
}


# Aplicaciones de argocd Desplegado con helm 

resource "helm_release" "nginx-ingress" {
      namespace        = "ingress-nginx"
      create_namespace = true      
      name       = "nginx-ingress"
      repository = "https://helm.nginx.com/stable"
      version = "1.0.2" 
      chart      = "nginx-ingress"
      values = [
        "${file("./values-helm/nginx-values.yaml")}"
       ]
  depends_on = [helm_release.aws-load-balancer-controller]
}