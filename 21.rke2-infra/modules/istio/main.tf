data "template_file" "values" {
  template = templatefile("${path.module}/values.yaml", {})
}

# Create a new rancher2 App in a new namespace
resource "rancher2_namespace" "istio" {
  name        = var.namespace
  project_id  = var.project_id
  description = "istio namespace"
}

# Create a new Rancher2 App V2 using
resource "rancher2_app_v2" "istio" {
  cluster_id    = var.cluster_id
  name          = var.app_name
  namespace     = var.namespace
  repo_name     = var.repo_name
  chart_name    = var.chart_name
  chart_version = var.chart_version
  values        = data.template_file.values.rendered

  force_upgrade = true
  timeouts {
    create = "10m" # default
    update = "10m" # default
    delete = "20m"
  }
}
