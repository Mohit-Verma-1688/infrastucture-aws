locals {
    env = "dev"

# make false for the component not to deploy
    cert-manager = "true" 
    cert-manager-issuers = "true" 
    ingress-controller = "true"
    aws-lb-controller = "false"
    argocd = "true"
    kube-prometheus-stack = "true"
}
