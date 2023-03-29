# [grafana](https://grafana.github.io/helm-charts)
# helm repo add grafana https://grafana.github.io/helm-charts
# helm install --name `grafana` --namespace prometheus grafana/grafana --create-namespace
# helm list -n prometheus; helm show chart grafana/grafana; helm get values grafana --all -n prometheus
resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = var.chart_version
  timeout          = 600 # default is 300

  // https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "service.nodePort"
    value = var.service_nodePort
  }
  set {
    name  = "persistence.enabled"
    value = true
  }
  set {
    name  = "persistence.type"
    value = "statefulset"
  }
  set {
    name  = "persistence.size"
    value = "1Gi"
  }
  set {
    name  = "persistence.storageClassName"
    value = var.storageClass
  }
  set {
    name  = "plugins"
    value = "{grafana-polystat-panel,grafana-clock-panel,vonage-status-panel,btplc-status-dot-panel,agenty-flowcharting-panel,ryantxu-annolist-panel,corpglory-progresslist-panel,briangann-datatable-panel,flant-statusmap-panel,grafana-piechart-panel,camptocamp-prometheus-alertmanager-datasource}"
  }
}

output "grafana" {
  value = helm_release.grafana.metadata
}
