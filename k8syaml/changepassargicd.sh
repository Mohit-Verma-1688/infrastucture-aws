#!/bin/bash
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret --template={{.data.password}} | base64 -d; echo)
NEWPASS=Newdelhi@15
echo $NEWPASS  
argocd login dev-argocd.themulticlouding.com --insecure --username admin --password $PASS
argocd account update-password --current-password $PASS --new-password $NEWPASS
#kubectl -n argocd delete secret argocd-initial-admin-secret
