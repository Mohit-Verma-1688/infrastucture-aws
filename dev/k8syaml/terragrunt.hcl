terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//k8syaml?ref=k8syaml-v0.0.15"
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
  #id = dependency.eks.outputs.eks_id
  openid_provider_arn = dependency.eks.outputs.openid_provider_arn
  enable_k8syaml      = include.env.locals.k8syaml
  
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}

dependency "argocd" {
  config_path = "../argocd"
  skip_outputs = true
}

generate "k8s_provider" {
  path      = "k8s-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster" "eks" {
    name = var.eks_name
    
}

data "aws_eks_cluster_auth" "eks" {
    name = var.eks_name
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
   #  exec {
   #  api_version = "client.authentication.k8s.io/v1beta1"
   #  command     = "aws"
   #  args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
   # }
    load_config_file       = false
}
EOF
}
