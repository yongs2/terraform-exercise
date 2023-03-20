#!/bin/sh

KUBE_VERSION=$(kubectl version --short | sed -n 's/Client Version: \([0-9]*\)*/\1/p')
# cat <<EOF | sudo tee kubeadm-config.yaml
# # kubeadm-config.yaml
# kind: ClusterConfiguration
# apiVersion: kubeadm.k8s.io/v1beta3
# kubernetesVersion: ${KUBE_VERSION}
# ---
# kind: KubeletConfiguration
# apiVersion: kubelet.config.k8s.io/v1beta1
# cgroupDriver: cgroupfs
# EOF
# sudo kubeadm init --config kubeadm-config.yaml
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=${KUBE_VERSION}
sleep 10

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes

# install calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Wait for control-plane's status
while true; do
STATUS=$(kubectl get nodes | grep control-plane | awk '{print $2}')
echo "control-plane status: [${STATUS}]"
if [[ "${STATUS}" == "Ready" ]]; then
    break
fi
sleep 5
done
