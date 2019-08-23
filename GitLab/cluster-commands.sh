# Get API URL
kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}'

# Get certificate file
kubectl get secret <secret name> -o jsonpath="{['data']['ca\.crt']}" | base64 --decode

# Copy the content from ---BEGIN all the way to the end.
# Create service accounts and get the token; see gitlab-service-account.yml file.

# Get the token
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab-admin | awk '{print $1}')