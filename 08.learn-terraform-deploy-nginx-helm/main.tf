# set config of provider kubernetes
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }

  # private registry
  registry {
    username = var.registry.username
    password = var.registry.password
    url      = var.registry.url
  }
}

# [nginx-ingress-controller](https://artifacthub.io/packages/helm/bitnami/nginx-ingress-controller)
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm install nginx-ingress-controller bitnami/nginx-ingress-controller --set service.type=ClusterIP
# helm list; helm show chart bitnami/nginx-ingress-controller
resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
