locals {
    env = "staging"  

# make false for the component not to deploy
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
