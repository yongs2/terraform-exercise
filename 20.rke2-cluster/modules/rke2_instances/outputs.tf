## Output value definitions

# output "install_etcd_hosts" {
#   value = data.template_file.install_etcd_hosts.rendered
# }

output "vm_ips" {
  value = join(" ", "${openstack_compute_instance_v2.rke2-instance.*.access_ip_v4}")
}
