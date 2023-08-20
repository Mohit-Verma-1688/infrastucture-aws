terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//argocd?ref=argocd-v0.1.2"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}


inputs = {
  env      = include.env.locals.env
  eks_name = dependency.eks.outputs.eks_name
  openid_provider_arn = dependency.eks.outputs.openid_provider_arn

  enable_argocd      = include.env.locals.argocd
  argocd_helm_verion = "5.42.0"
  aws_ssm_key_name = "argocd-terraform-key"
  private_git_repo = "git@github.com:Mohit-Verma-1688/applications.git"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}


dependency "ingress-controller" {
  config_path = "../ingress-controller"
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

