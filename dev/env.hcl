locals {
    env = "dev"

# make false for the component not to deploy
    cert-manager = "true"   
    ingress-controller = "true"
    aws-lb-controller = "false"
    argocd = "false"
}
