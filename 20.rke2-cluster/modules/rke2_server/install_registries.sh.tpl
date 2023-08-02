#!/bin/sh

# wait /etc/rancher/rke2/registries.yaml
while [ ! -f /etc/rancher/rke2/registries.yaml ]; do 
    echo "wait /etc/rancher/rke2/registries.yaml"
    sleep 10;
done

# install /etc/rancher/rke2/registries.yaml
sudo /usr/bin/cat << EOF | sudo /usr/bin/tee /etc/rancher/rke2/registries.yaml
mirrors:
%{ for idx, registry in private_container_registries ~}
  "${registry.name}":
    endpoint:
      - "${registry.endpoint}"
%{ endfor ~}
configs:
%{ for idx, registry in private_container_registries ~}
  "${registry.name}":
    auth:
      username: ${registry.username}
      password: ${registry.password}
    tls:
      insecure_skip_verify: ${registry.insecure_skip_verify}
%{ endfor ~}
EOF

# # wait /etc/rancher/rke2/rke2.yaml
# while [ ! -f /etc/rancher/rke2/rke2.yaml ]; do 
#     echo "wait /etc/rancher/rke2/rke2.yaml"
#     sleep 10;
# done

# # cp /etc/rancher/rke2/rke2.yaml
# if [ ! -d $HOME/.kube ] ; then
#   mkdir -p $HOME/.kube
# fi
# sudo cp -f /etc/rancher/rke2/rke2.yaml $HOME/.kube/config
# sudo chmod 644 $HOME/.kube/config
# sudo sed -i -e "s/127.0.0.1/$(hostname -i)/g" $HOME/.kube/config
