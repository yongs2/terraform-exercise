#!/bin/bash

# master node 설정
export INSTALL_LOG=/var/log/k8s_install.log
echo "START SCRIPT >>>>>>> INSTALL_LOG=${INSTALL_LOG}, HOME=${HOME}"

# master node 초기화
echo ">> kubeadm init"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 &>> $INSTALL_LOG

# KUBECONFIG 설정
## for ubuntu
mkdir -p ~/.kube
sudo cp -f /etc/kubernetes/admin.conf ${HOME}/.kube/config
sudo chown $(id -u):$(id -g) ${HOME}/.kube/config
## for root
sudo mkdir -p /root/.kube
sudo cp -f /etc/kubernetes/admin.conf /root/.kube/config
export KUBECONFIG=${HOME}/.kube/config

# CNI 플러그인 설치
CALICO_VER=v3.25.0
echo ">> install calico ${CALICO_VER}"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VER}/manifests/calico.yaml &>> $INSTALL_LOG
sudo curl -L https://github.com/projectcalico/calico/releases/download/${CALICO_VER}/calicoctl-linux-amd64 -o /usr/local/bin/calicoctl && sudo chmod +x /usr/local/bin/calicoctl &>> $INSTALL_LOG

kubectl taint nodes --all node-role.kubernetes.io/control-plane- &>> $INSTALL_LOG

# kubectl 자동 완성 설정
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Wait for control-plane's status
sudo echo ">> Wait for control-plane's status"
while true; do
STATUS=$(kubectl get nodes | grep control-plane | awk '{print $2}')
echo "control-plane status: [${STATUS}]"
if [[ "${STATUS}" == "Ready" ]]; then
    break
fi
sleep 5
done
