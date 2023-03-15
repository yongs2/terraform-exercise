## Output value definitions

output "master" {
  value = [
    // openstack_compute_instance_v2.master 을 순회하면서 이름과 ip 정보를 출력
    for server in openstack_compute_instance_v2.master : {
      name : server.name
      address : server.network.0.fixed_ip_v4
    }
  ]
}

output "worker" {
  value = [
    for server in openstack_compute_instance_v2.worker : {
      name : server.name
      address : server.network.0.fixed_ip_v4
    }
  ]
}
