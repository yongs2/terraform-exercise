data "template_file" "values" {
  template = templatefile("${path.module}/values.yaml", {
    storage_class      = var.storage_class
    replica_count      = var.replica_count
    volume_permissions = length(var.storage_class) > 0 ? true : false
    node_port          = var.node_port
  })
}

# Create a new rancher2 App in a new namespace
resource "rancher2_namespace" "etcd" {
  name        = var.namespace
  project_id  = var.project_id
  description = "etcd namespace"
}

# Create a new Rancher2 App V2 using
resource "rancher2_app_v2" "etcd" {
  cluster_id    = var.cluster_id
  name          = var.app_name
  namespace     = var.namespace
  repo_name     = var.repo_name
  chart_name    = var.chart_name
  chart_version = var.chart_version
  values        = data.template_file.values.rendered

  timeouts {
    create = "10m" # default
    update = "10m" # default
    delete = "20m"
  }
}
