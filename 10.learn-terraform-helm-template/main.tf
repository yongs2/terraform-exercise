# set config of provider kubernetes
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

# [mariadb](https://artifacthub.io/packages/helm/bitnami/mariadb)
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm template bitnami/mariadb
data "helm_template" "mariadb_instance" {
  name       = "mariadb-instance"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"

  chart   = "mariadb"
  version = "11.5.3"

  show_only = [
    "templates/primary/statefulset.yaml",
    "templates/primary/svc.yaml",
  ]

  set {
    name  = "primary.service.ports.mysql"
    value = "13306"
  }

  set_sensitive {
    name  = "auth.rootPassword"
    value = "secretpassword"
  }
}

resource "local_file" "mariadb_manifests" {
  for_each = data.helm_template.mariadb_instance.manifests

  filename = "./${each.key}"
  content  = each.value
}
