# Create a VM in OpenStack and install rke2-cluster

- [provider openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest)
  - [source](https://github.com/terraform-provider-openstack/terraform-provider-openstack)
- [provider rancher2](https://registry.terraform.io/providers/rancher/rancher2/latest)
  - [source](https://github.com/rancher/terraform-provider-rancher2)

## Initialize your configuration

- Initialize the Terraform configuration.

```sh
rm -f ~/.ssh/id_rsa && ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa && ls -al /root/.ssh/id_rsa.pub

terraform init
terraform init -upgrade

terraform fmt -recursive && terraform validate
```

## Apply

```sh
export TF_VAR_fixed_ip_v4='["192.168.5.59","192.168.5.60","192.168.5.63"]'

terraform plan -var "instance_prefix=rke2-dev" -var "vm_count=3"
terraform apply -auto-approve -var "instance_prefix=rke2-dev" -var "vm_count=3"

# After creating rke2-dev, it takes about 15 minutes for all to register

# Destroy rancher2_cluster_v2
terraform destroy -auto-approve -target null_resource.install
terraform destroy -auto-approve -target rancher2_cluster_v2.rke2-dev
# Create rke2-dev with rancher2_cluster_v2
terraform apply -auto-approve -target rancher2_cluster_v2.rke2-dev
# Run regitration script
terraform apply -auto-approve -target null_resource.install
terraform state list
```

## test

```sh
VM_IPS=$(terraform output vm_ips | sed -E 's/.*"([^"]+)".*/\1/')
for VM_IP in ${VM_IPS}; do
  echo ${VM_IP}
  ssh rocky@${VM_IP} -i ~/.ssh/id_rsa
done

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
