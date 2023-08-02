# Create a new rancher2 App in a new namespace
resource "rancher2_namespace" "openebs" {
  name        = var.namespace
  project_id  = var.project_id
  description = "openebs namespace"
}

# Create a new Rancher2 App V2 using
resource "rancher2_app_v2" "openebs" {
  cluster_id    = var.cluster_id
  name          = var.app_name
  namespace     = var.namespace
  repo_name     = var.repo_name
  chart_name    = var.chart_name
  chart_version = var.chart_version

  cleanup_on_fail = true
  timeouts {
    create = "10m" # default
    update = "10m" # default
    delete = "20m"
  }
}
