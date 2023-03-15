#!/bin/sh

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release net-tools
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo mkdir /etc/docker
echo '{"exec-opts": ["native.cgroupdriver=systemd"],"log-driver":"json-file","log-opts": {"max-size":"100m"},"storage-driver":"overlay2"}' | sudo tee /etc/docker/daemon.json
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker && sudo systemctl start docker
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm config images pull
