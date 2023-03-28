# Create a VM in OpenStack and install k8s control-plane and worker nodes

- [Infrastructure as Code with Terraform](https://github.com/Abbas-gheydi/k8s_openstack_terraform)
- [provider openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest)
  - [source](https://github.com/terraform-provider-openstack/terraform-provider-openstack)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
ssh-keygen -t rsa && ls -al /root/.ssh/id_rsa.pub

terraform init
terraform init -upgrade

terraform fmt -recursive && terraform validate
```

## Apply

```sh
export TF_VAR_fixed_ip_v4='["192.168.5.48","192.168.5.59","192.168.5.60"]'

terraform plan -var "master_vm_count=1" -var "worker_vm_count=1"
terraform apply -auto-approve -var "master_vm_count=1" -var "worker_vm_count=1"
```

## test

```sh
VM_IPS=$(terraform show -json | jq -r '.values.outputs[].value[].address')
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
