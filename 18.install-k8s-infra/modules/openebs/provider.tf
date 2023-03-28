# set config of provider kubernetes
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}
