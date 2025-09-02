
# Prometheus Installation with Helm 

## Prometheus (standalone)

1) Add Prometheus Helm repo 
- step: Add Helm repo
- command: ```helm repo add prometheus-community https://prometheus-community.github.io/helm-charts```

2) Update Helm repo 
- step: Update Helm repo
 - command: ```helm repo update``` 

3) Create prometheus namespace 
- step: Create namespace
- command: ```kubectl create namespace prometheus``` 

or 

- manifest: ns.yaml 
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: prometheus
  labels:
    name: prometheus
```

- command: kubectl apply -f ns.yaml

4) Install Prometheus into 'prometheus' namespace 
- step: Install Prometheus
 - command: ```helm install prometheus prometheus-community/prometheus -n prometheus -f values.yaml```

 - OR ```helm install prometheus prometheus-community/prometheus -n prometheus -f prometheus/values.yaml --create-namespace``` (???)


```bash
 helm install prometheus prometheus-community/prometheus \
  --namespace observability --create-namespace \
  --set alertmanager.persistence.storageClass="gp2" \
  --set server.persistentVolume.storageClass="gp2"
  ```

  ```bash
  helm install prometheus prometheus-community/prometheus \
  --namespace observability --create-namespace \
  --set alertmanager.persistence.storageClass="gp2" \
  --set server.persistentVolume.storageClass="gp2" \
  --set server.service.type=LoadBalancer
  ```

5) Verify the Prometheus pods are running 
- step: Check pods
  command: ```kubectl get pods -n prometheus``` 

6) Port forward Prometheus UI 
- step: Port forward to access UI
  command: ```kubectl port-forward -n prometheus deploy/prometheus-server 9090``` 

7) Open in browser 
- step: Access UI
- url: [UI](http://localhost:9090)
- at localhost on port 9090


## counter app
custom metric: button_clicks_total


## Grafana (standalone):

- ```helm repo add grafana https://grafana.github.io/helm-charts```
- ```helm repo update```

- ```kubectl get secret --namespace observability monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo```

### standard
```bash
helm install grafana grafana/grafana \
  --namespace observability  \
  --set service.type=LoadBalance
  ```

### with persistance 
```bash
helm install grafana grafana/grafana \
  --namespace observability --create-namespace \
  --set service.type=LoadBalancer \
  --set persistence.enabled=true \
  --set persistence.storageClassName="gp2"
  ```

```bash
  helm upgrade monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.persistence.enabled=true \
  --set grafana.persistence.storageClassName="gp2" \
  --set grafana.persistence.size="10Gi"
  ```

### sample metrics
 - node_cpu_seconds_total
 - kube_pod_info
 - container_cpu_usage_seconds_total


 ## Kube-prom-stack

 ### add repo
 (not needed if used helm for standalone prometheus)
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### install
```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
 --namespace observability --create-namespace \
 --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName="gp2" \
 --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage="50Gi" \
 --set prometheus.service.type=LoadBalancer \
 --set grafana.service.type=LoadBalancer \
 --set grafana.persistence.enabled=true \
 --set grafana.persistence.storageClassName="gp2" \
 --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName="gp2" \
 --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage="10Gi"
 ```

### install with values.yaml
```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace observability --create-namespace \
  -f prometheus-notes/kube-prom-values.yaml
```

### uninstall

- ```helm uninstall monitoring -n observability```

- ```kubectl delete namespace observability```

### These metrics are automatically available:
- kube_pod_status_phase (pod states)
- kube_deployment_status_replicas (deployment health)
- kube_node_status_condition (node health)
- node_cpu_seconds_total (CPU usage)
- container_memory_usage_bytes (memory usage)

### LB IPs

#### basic
- Grafana Dashboard: ```kubectl get svc monitoring-grafana -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'```

- Prom Server: ```kubectl get svc monitoring-kube-prometheus-prometheus -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'```

#### pretty

```bash
echo "Grafana Dashboard: http://$(kubectl get svc monitoring-grafana -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):80"
```

```bash
echo "Prometheus Server: http://$(kubectl get svc monitoring-kube-prometheus-prometheus -n observability -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):9090"
```