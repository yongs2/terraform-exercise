# set config of provider rancher2
provider "rancher2" {
  # Configuration options
  api_url    = var.rancher2_api_endpoint
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
  insecure   = true
}

# set config of provider kubernetes
provider "kubernetes" {
  config_path = var.kube_config_path
}

data "rancher2_cluster" "rke2-dev" {
  name = var.rke2_dev
}

# Create a new Rancher2 Catalog V2 using url
resource "rancher2_catalog_v2" "bitnami" {
  cluster_id = data.rancher2_cluster.rke2-dev.id
  name       = "bitnami"
  url        = "https://charts.bitnami.com/bitnami"
}

data "rancher2_project" "system" {
  cluster_id = data.rancher2_cluster.rke2-dev.id
  name       = "System"
}

data "rancher2_project" "default" {
  cluster_id = data.rancher2_cluster.rke2-dev.id
  name       = "Default"
}

# Create a new rancher2 App (openebs) in a new namespace (openebs)
module "openebs" {
  source        = "./modules/openebs"
  app_name      = "openebs"
  namespace     = "openebs"
  repo_name     = "rancher-partner-charts"
  chart_version = "3.7.0"
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
}

# Create a new rancher2 App (metallb) in a new namespace (metallb-system)
module "metallb" {
  source        = "./modules/metallb"
  app_name      = "metallb"
  namespace     = "metallb-system"
  repo_name     = "rancher-partner-charts"
  chart_version = "0.13.10"
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
}

# Deploy Rancher monitoring
module "monitoring" {
  source        = "./modules/monitoring"
  app_name      = "rancher-monitoring"
  namespace     = "cattle-monitoring-system"
  repo_name     = "rancher-charts"
  chart_version = "102.0.1+up40.1.2"
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
}

# Create a new rancher2 App (istio) in a new namespace (istio-system)
module "istio" {
  depends_on = [module.monitoring] # Rancher-istio requires rancher-monitoring

  source        = "./modules/istio"
  app_name      = "istio"
  namespace     = "istio-system"
  repo_name     = "rancher-charts"
  chart_version = "102.2.0+up1.17.2"
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
}

# Create a new rancher2 App (etcd) in a new namespace (etcd)
module "etcd" {
  depends_on = [module.openebs] # requires storage_class

  source        = "./modules/etcd"
  app_name      = "etcd"
  namespace     = "etcd"
  repo_name     = "bitnami"
  chart_version = "9.0.7"
  node_port     = 31359
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
  storage_class = "openebs-hostpath"
}

# Create a new rancher2 App (redis-cluster) in a new namespace (redis-cluster)
module "redis-cluster" {
  depends_on = [module.openebs] # requires storage_class

  source        = "./modules/redis-cluster"
  app_name      = "redis6"
  namespace     = "redis6"
  repo_name     = "bitnami"
  chart_version = "8.6.11"
  project_id    = data.rancher2_project.default.id
  cluster_id    = data.rancher2_cluster.rke2-dev.id
  storage_class = "openebs-hostpath"
}
