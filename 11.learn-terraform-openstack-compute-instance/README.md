# Manages a V2 VM instance resource within OpenStack

- [Manages a V2 VM instance resource within OpenStack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2)

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
terraform apply -auto-approve
```

## test

```sh
ssh ubuntu@$(terraform show | grep address | sed -E 's/.*"([^"]+)".*/\1/')

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
