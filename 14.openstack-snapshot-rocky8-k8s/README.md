# Create a VM in OpenStack and install rocky linux 8.7 and install k8s and snapshot it

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
export TF_VAR_fixed_ip_v4="192.168.5.48"

terraform plan -var "instance_prefix=my5g-test"
terraform apply -auto-approve -var "instance_prefix=my5g-test"
```

## test

```sh
VM_IP=$(terraform show -json | jq -r '.values.outputs.basenode.value.address')
echo ${VM_IP}
ssh rocky@${VM_IP} -i ~/.ssh/id_rsa

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
