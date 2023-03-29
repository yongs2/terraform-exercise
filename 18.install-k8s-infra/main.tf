module "openebs" {
  source           = "./modules/openebs"
  kube_config_path = var.kube_config_path
  chart_version    = var.openebs.chart_version
  namespace        = var.openebs.namespace
}

module "prometheus" {
  source           = "./modules/prometheus"
  kube_config_path = var.kube_config_path
  chart_version    = var.prometheus.chart_version
  namespace        = var.prometheus.namespace
  storageClass     = var.prometheus.storageClass
  service_nodePort = var.prometheus.service_nodePort
}

module "grafana" {
  source           = "./modules/grafana"
  kube_config_path = var.kube_config_path
  chart_version    = var.grafana.chart_version
  namespace        = var.grafana.namespace
  storageClass     = var.prometheus.storageClass
  service_nodePort = var.grafana.service_nodePort
}

module "istio" {
  source           = "./modules/istio"
  kube_config_path = var.kube_config_path
  chart_version    = var.istio.chart_version
  namespace        = var.istio.namespace
}

# FIXME: Excluded due to high cassandra memory usage
# module "jaeger" {
#   source           = "./modules/jaeger"
#   kube_config_path = var.kube_config_path
#   chart_version    = var.jaeger.chart_version
#   namespace        = var.jaeger.namespace
#   service_nodePort = var.jaeger.service_nodePort
# }

output "msg" {
  value = "all instacnes are deployed"
}
