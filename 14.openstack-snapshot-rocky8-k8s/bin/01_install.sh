#!/bin/sh
# https://www.linuxtechi.com/install-kubernetes-cluster-on-rocky-linux/

# Step 2) Disable Swap and Set SELinux in permissive mode
sudo echo ">>> Step 2..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo setenforce 0
sudo sleep 10
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Step 3) Configure Firewall Rules on Master and Worker Nodes
sudo echo ">>> Step 3..."
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=30000-32767/tcp                                                  
sudo firewall-cmd --reload
sudo sleep 10
sudo modprobe br_netfilter
sudo sh -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo sh -c "echo '1' > /proc/sys/net/ipv4/ip_forward"
sudo sleep 10

# Step 4) Install Docker on Master and Worker Nodes
sudo echo ">>> Step 4..."
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo sleep 10
sudo chmod 666 /var/run/docker.sock && echo ">>> docker.sock=$(ls -al /var/run/docker.sock)"
sudo sleep 10

# Step 5) Install kubelet, Kubeadm and kubectl
sudo echo ">>> Step 5..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo echo "install kubelet, kubeadm, kubectl"
sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo sleep 10
sudo systemctl enable --now kubelet
sudo sleep 10
echo echo "kubelet=$(systemctl status kubelet)"

# Step 6) clean cache
sudo echo ">>> Step 6..."
echo "Before=$(sudo du -sh /var/cache/dnf)"
sudo dnf clean all
echo "After=$(sudo du -sh /var/cache/dnf)"
