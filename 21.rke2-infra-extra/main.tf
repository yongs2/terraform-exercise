# set config of provider kubernetes
provider "kubernetes" {
  config_path = var.kube_config_path
}

# 03.rke2-infra 설치 후 실행해야 함
# kubectl apply -f metallb_kind.yaml
module "metallb_kind" {
  # depends_on = [module.metallb] # After installing metallb, register ipaddress pool

  source             = "./modules/metallb_kind"
  namespace          = "metallb-system"
  pool_name          = "loadbalanced"
  l2adver_name       = "l2adver"
  external_ip_ranges = var.external_ip_ranges
}
