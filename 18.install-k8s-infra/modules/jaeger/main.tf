# [jaeger](https://artifacthub.io/packages/helm/jaegertracing/jaeger)
# helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
# helm install jaeger jaegertracing/jaeger --namespace jaeger --create-namespace
# helm list; helm show chart jaeger/jaeger; helm get values jaeger --all
resource "helm_release" "jaeger" {
  name             = "jaeger"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  version          = var.chart_version
  timeout          = 600 # default is 300

  set {
    name  = "server.global.scrape_interval"
    value = "15s"
  }

  set {
    name  = "query.service.type"
    value = "NodePort"
  }
  set {
    name  = "query.service.nodePort"
    value = var.service_nodePort
  }
}

output "jaeger" {
  value = helm_release.jaeger.metadata
}
