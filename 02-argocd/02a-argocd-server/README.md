kustomize build --enable-helm . | kubectl create -f-

# To destroy
kustomize build --enable-helm . | kubectl delete -f-