# [istio](https://istio.io/latest/docs/setup/install/helm/)
# helm repo add istio https://istio-release.storage.googleapis.com/charts

# helm install istio-base istio/base -n istio-system
# helm list -n istio-system; helm show chart istio/base; helm get values istio-base --all -n istio-system
resource "helm_release" "istio-base" {
  name             = "istio-base"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = var.chart_version
  timeout          = 600 # default is 300
}

# helm install istiod istio/istiod -n istio-system
# helm list -n istio-system; helm show chart istio/istiod; helm get values istio-istiod --all -n istio-system
resource "helm_release" "istio-istiod" {
  depends_on = [
    helm_release.istio-base
  ]
  name             = "istio-istiod"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = var.chart_version
  wait             = true
  timeout          = 600 # default is 300
}

# helm install istio-ingress istio/gateway -n istio-system --wait
# helm list -n istio-system; helm show chart istio/gateway; helm get values istio-ingress --all -n istio-system
resource "helm_release" "istio-ingress" {
  depends_on = [
    helm_release.istio-base,
    helm_release.istio-istiod
  ]

  name             = "istio-ingress"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = var.chart_version
  wait             = true
  timeout          = 600 # default is 300
}

output "istio-base" {
  value = helm_release.istio-base.metadata
}

output "istio-istiod" {
  value = helm_release.istio-istiod.metadata
}

output "istio-ingress" {
  value = helm_release.istio-ingress.metadata
}
