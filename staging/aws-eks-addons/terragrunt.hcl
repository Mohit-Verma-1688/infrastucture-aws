terraform {
  source = "git::git@github.com:Mohit-Verma-1688/infrastucture-modules.git//aws-eks-addons?ref=aws-eks-addons-v0.0.1"
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

  enable_aws-eks-addon      = include.env.locals.aws-eks-addon
  aws-ebs-csi_version = "v1.11.4-eksbuild.1"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks_name            = "demo"
    openid_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
  }
}

