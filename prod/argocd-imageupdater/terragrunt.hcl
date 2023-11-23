#terraform {
#  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//argocd-imageupdater?ref=argocd-imageupdater-v0.0.2"
#}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = "${get_terragrunt_dir()}/../../_env/prod.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//argocd-imageupdater?ref=${include.env.locals.argocd-imageupdater-module}"
}

inputs = {
  env      = include.env.locals.env
  eks_name = dependency.eks.outputs.eks_name
  openid_provider_arn = dependency.eks.outputs.openid_provider_arn

  enable_argocd-imageup      = include.env.locals.argocd-imageupdater
  argocd-imageup_helm_verion = "0.8.4"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}


dependency "kube-prometheus-stack" {
  config_path = "../kube-prometheus-stack"
  skip_outputs = true
}

generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "eks" {
    name = var.eks_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
EOF
}

generate "kubernetes_provider" {
  path      = "k8s-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks1" {
    name = var.eks_name
}

data "aws_eks_cluster_auth" "eks1" {
    name = var.eks_name
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.eks1.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks1.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks1.token
}
EOF
}

