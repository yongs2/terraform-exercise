# [prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)
# helm repo add prometheus https://prometheus-community.github.io/helm-charts
# helm install --name `prometheus` --namespace prometheus prometheus/prometheus --create-namespace
# helm list -n prometheus; helm show chart prometheus/prometheus; helm get values prometheus --all -n prometheus
resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.chart_version

  // https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus/values.yaml
  set {
    name  = "server.global.scrape_interval"
    value = "15s"
  }
  set {
    name  = "server.persistentVolume.storageClass"
    value = var.storageClass
  }
  set {
    name  = "server.service.type"
    value = "NodePort"
  }
  set {
    name  = "server.service.nodePort"
    value = var.service_nodePort
  }

  // https://github.com/prometheus-community/helm-charts/blob/main/charts/alertmanager/values.yaml
  set {
    name  = "alertmanager.persistence.storageClass"
    value = var.storageClass
  }
  set {
    name  = "alertmanager.service.type"
    value = "NodePort"
  }
  set {
    name  = "nodeExporter.hostNetwork"
    value = "false"
  }
}
