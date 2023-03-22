provider "openstack" {}

# openstack flavor list; openstack flavor show C2M2D20
resource "openstack_compute_flavor_v2" "flavor" {
  name  = "C2M2D20"
  ram   = "2048"
  vcpus = "2"
  disk  = "20"
}

# openstack keypair list; openstack keypair show "${var.instance_prefix}-keypair"
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.instance_prefix}-keypair"
  public_key = file("${var.ssh_key_file}.pub")
}

# openstack server list; openstack server show basenode
resource "openstack_compute_instance_v2" "basenode" {
  name       = format("${var.instance_prefix}-%02d", 1)
  image_name = var.image
  flavor_id  = openstack_compute_flavor_v2.flavor.id
  key_pair   = openstack_compute_keypair_v2.keypair.name
  security_groups = ["default"]

  network {
    name        = var.network_name
    fixed_ip_v4 = var.fixed_ip_v4
  }
}

# install Kubernetes - basenode
resource "null_resource" "install_kuberernetes_basenode" {
  depends_on = [openstack_compute_instance_v2.basenode]

  provisioner "remote-exec" {
    scripts = [
      "./bin/01_install.sh",
    ]

    connection {
      type        = "ssh"
      user        = "rocky"
      private_key = file("${var.ssh_key_file}")
      host        = openstack_compute_instance_v2.basenode.access_ip_v4
    }
  }
}

# null_resource to take snapshots and create images
resource "null_resource" "snapshot_and_create_image" {
  # Runs after the VM is created.
  depends_on = [
    openstack_compute_instance_v2.basenode,
    null_resource.install_kuberernetes_basenode,
  ]

  triggers = {
    instance_id = openstack_compute_instance_v2.basenode.id
  }

  # Scripts for taking snapshots and creating images
  provisioner "local-exec" {
    command = <<EOF
      # Setting environment variables to run openstack
      source /workspace/.openstack.profile
      
      # Delete previously created image
      openstack image delete ${var.snapshot} && echo "delete old image ${var.snapshot}"
      sleep 10
      
      # Create snapshot image
      echo "snapshot.instance.id: [${openstack_compute_instance_v2.basenode.id}]"
      openstack server image create --name ${var.snapshot} ${openstack_compute_instance_v2.basenode.id}
      
      # Wait for image to save
      while true; do
        openstack image show -f value -c status "${var.snapshot}" > status.log
        echo "image status: [$(cat status.log)]"
        if [[ $(cat status.log) == "active" ]]; then
          break
        fi
        sleep 5
      done
    EOF
  }
}
