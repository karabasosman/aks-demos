helm delete --purge online-store

helm delete --purge prometheus-operator

helm delete --purge prometheus-adaptor

helm delete --purge kube-lego

helm delete --purge grafana

helm delete --purge vn-affinity

kubectl delete statefulsets prometheus-prometheus

kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete podmonitors.monitoring.coreos.com
kubectl delete prometheuses.monitoring.coreos.com
kubectl delete prometheusrules.monitoring.coreos.com
kubectl delete servicemonitors.monitoring.coreos.com
kubectl delete thanosrulers.monitoring.coreos.com

kubectl label namespace default vn-affinity-injection-