locals {
    env = "dev"

#  make false for the component not to deploy. Other values are controlled by pipeline at runtime.
   
# VPC paramaeters, VPC is ON by default. 
    azs           = "["us-east-1a", "us-east-1b"]"   
    aws-eks-addon = "false"
    cert-manager = "false" 
    cert-manager-issuers = "false"
    external-dns = "false" 
    ingress-controller = "false"
    aws-lb-controller = "false"
    argocd = "false"
    kube-prometheus-stack = "false"
    argocd-imageupdater = "false"
}
