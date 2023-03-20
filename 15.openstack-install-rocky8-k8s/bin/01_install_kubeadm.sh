#!/bin/sh

# wait 30 seconds for booting
echo ">>> wait for booting"
sleep 30

# FIXME: 이전 snapshot(${var.image}) 에 저장된 rpm 이 제대로 설치가 안된 것 같아서, 재설치
sudo dnf remove -y kubelet kubeadm kubectl
sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Step 6) Install Kubernetes Cluster with Kubeadm
# https://stackoverflow.com/questions/59653331/kubernetes-centos-8-tc-command-missing-impact
sudo dnf install -y iproute-tc
sleep 10

# https://velog.io/@makengi/K8s-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EA%B5%AC%EC%84%B1%EC%A4%91-%EC%97%90%EB%9F%AC
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sleep 10
sudo kubeadm config images pull
sleep 10

echo ">>> Installation complete for kubeadm"
