terraform {
  required_providers {
    helm = {
      version = "2.6.0"
    }
    kubernetes = {
      version = "2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
  required_version = "~> 1.5.0"
}



provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.demo_eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo_eks.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.demo_eks.name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo_eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo_eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.demo_eks.token

}

provider "kubectl" {
  host                   = data.aws_eks_cluster.demo_eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo_eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.demo_eks.token
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.demo_eks.name]
    command = "aws"
 }
}

