# Run only in dev/test environments to clean up the previous resources.
kubectl delete storageclass --all
kubectl delete pvc --all
kubectl delete pv --all
kubectl delete svc express-nodejs-service # kubernetes service is necessary
kubectl delete deployment --all
kubectl delete pods --all
