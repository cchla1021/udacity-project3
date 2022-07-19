echo "default namespace"
kubectl get deployment,pods,svc -n default
echo "-------------------------------------------------------"
echo "monitoring namespace"
kubectl get deployment,pods,svc -n monitoring
echo "-------------------------------------------------------"
echo "observability namespace"
kubectl get deployment,pods,svc -n observability
echo "-------------------------------------------------------"
echo "kube-system namespace"
kubectl get pods -n kube-system
echo "-------------------------------------------------------"
