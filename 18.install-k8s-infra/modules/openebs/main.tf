# [openebs](https://artifacthub.io/packages/helm/openebs/openebs)
# helm repo add openebs https://openebs.github.io/charts
# helm install --name `openebs` --namespace openebs openebs/openebs --create-namespace
# helm list; helm show chart openebs/openebs; helm get values openebs --all
resource "helm_release" "openebs" {
  name             = "openebs"
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://openebs.github.io/charts"
  chart            = "openebs"
  version          = var.chart_version
}
