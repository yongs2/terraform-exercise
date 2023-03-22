#!/bin/sh

# Step 4) Initialize kubeadm
sudo echo ">>> Step 4..."
KUBE_VERSION=$(kubectl version --short | sed -n 's/Client Version: \([0-9]*\)*/\1/p')
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=${KUBE_VERSION}
sleep 10

# Step 5) Copy the kubeconfig file to the ~/.kube directory 
sudo echo ">>> Step 5..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes

# Step 6) Install calico
sudo echo ">>> Step 6..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Step 7) Wait for control-plane's status
sudo echo ">>> Step 7..."
while true; do
STATUS=$(kubectl get nodes | grep control-plane | awk '{print $2}')
echo "control-plane status: [${STATUS}]"
if [[ "${STATUS}" == "Ready" ]]; then
    break
fi
sleep 5
done
