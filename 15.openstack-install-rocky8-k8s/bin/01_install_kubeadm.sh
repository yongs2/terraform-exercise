#!/bin/sh

# wait 30 seconds for booting
echo ">>> wait for booting"
sleep 30

# Step 1) chmod docker.sock for containerd
sudo echo ">>> Step 1..."
# FIXME: snapshot(${var.image}) 이미지에서 docker.sock 권한을 변경하였으나, 제대로 반영이 안되어서 다시 변경함
sudo chmod 666 /var/run/docker.sock && echo ">>> docker.sock=$(ls -al /var/run/docker.sock)"

# Step 2) install iproute-tc for kubeadm
sudo echo ">>> Step 2..."
# https://stackoverflow.com/questions/59653331/kubernetes-centos-8-tc-command-missing-impact
sudo dnf install -y iproute-tc
sleep 10

# Step 3) Reconfigure containerd for kubeadm
sudo echo ">>> Step 3..."
# https://velog.io/@makengi/K8s-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EA%B5%AC%EC%84%B1%EC%A4%91-%EC%97%90%EB%9F%AC
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sleep 10
sudo kubeadm config images pull
sleep 10

echo ">>> Installation complete for kubeadm"
