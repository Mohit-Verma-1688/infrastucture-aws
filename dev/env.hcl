locals {
    env = "dev"

# make false for the component not to deploy
    aws-eks-addon = "true"
    cert-manager = "true" 
    cert-manager-issuers = "true"
    external-dns = "true" 
    ingress-controller = "true"
    aws-lb-controller = "true"
    argocd = "true"
    kube-prometheus-stack = "true"
    argocd-imageupdater = "false"
}
