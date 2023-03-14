## Output value definitions

output "address" {
  value = openstack_compute_instance_v2.basic.network[0].fixed_ip_v4
}
