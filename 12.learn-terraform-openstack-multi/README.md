# Multiple Instances

- [Multiple Instances](https://github.com/terraform-provider-openstack/terraform-provider-openstack/tree/main/examples/multiple-vm-with-floating-ip)

- [provider openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest)
  - [source](https://github.com/terraform-provider-openstack/terraform-provider-openstack)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
ssh-keygen -t rsa && ls -al /root/.ssh/id_rsa.pub

terraform init
terraform init -upgrade

terraform validate
```

## Apply

```sh
terraform plan
terraform apply -auto-approve -var "instance_count=3"
```

## test

```sh
VM_IPS=$(terraform show -json | jq -r '.values.outputs.address.value[]')
for VM_IP in ${VM_IPS}; do
  echo ${VM_IP}
  ssh ubuntu@${VM_IP}
done

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
