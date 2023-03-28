## Output value definitions

output "basenode" {
  value = {
    name : openstack_compute_instance_v2.basenode.name
    address : openstack_compute_instance_v2.basenode.network.0.fixed_ip_v4
    image : var.snapshot
  }
}
