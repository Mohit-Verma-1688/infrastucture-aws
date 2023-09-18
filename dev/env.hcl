locals {
    env = "dev"

# make false for the component not to deploy
    cert-manager = "true" 
    cert-manager-issuers = "true"
    external-dns = "true" 
    ingress-controller = "true"
    aws-lb-controller = "true"
    argocd = "true"
    kube-prometheus-stack = "true"
    argocd-imageupdater = "false"
}
