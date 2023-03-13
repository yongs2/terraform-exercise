# set config of provider kubernetes
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

# [redis](https://artifacthub.io/packages/helm/bitnami/redis)
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm install my-redis-release bitnami/redis --set architecture=replication --set metrics.enabled=true -f values.yaml
# helm list; helm show chart bitnami/redis; helm get values my-redis-release --all
resource "helm_release" "example" {
  name       = "my-redis-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.8.4"

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "architecture"
    value = "replication"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }
}
