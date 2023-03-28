# Install prerequisite packages on k8s infra

- [provider helm](https://registry.terraform.io/providers/hashicorp/helm/latest)
  - [source](https://github.com/hashicorp/terraform-provider-helm)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade

export TF_VAR_kube_config_path="/workspace/17.openstack-ansible-kubespray-k8s/k8s-master-01.kubeconfig"
echo "TF_VAR_kube_config_path=${TF_VAR_kube_config_path}"

terraform validate
```

## Apply

```sh
terraform plan
terraform apply -auto-approve

# grafana 만 재설치
terraform destroy -auto-approve -target module.grafana.helm_release.grafana
terraform apply -auto-approve -target module.grafana.helm_release.grafana
```

## test

```sh
terraform show
terraform state list
```

## Destroy

```sh
# jager 가 cassandra 를 사용하므로, 메모리 사용률이 높은 경우 삭제
terraform destroy -auto-approve -target module.jaeger.helm_release.jaeger

terraform destroy -auto-approve
```
