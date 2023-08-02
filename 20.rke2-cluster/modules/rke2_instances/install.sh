#!/bin/sh
USER=rocky
HOME=/home/$USER

# for log
export INSTALL_LOG=/var/log/k8s_install.log
sudo touch $INSTALL_LOG
sudo chown $USER $INSTALL_LOG

# net-tools 설치
sudo dnf -y install net-tools &>> $INSTALL_LOG

# [Install k8s with IPVS mode](https://devopstales.github.io/kubernetes/k8s-ipvs/)
sudo dnf -y install ipset ipvsadm &>> $INSTALL_LOG

sudo cat << EOF | sudo tee /etc/sysconfig/modules/ipvs.modules
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
sudo chmod 755 /etc/sysconfig/modules/ipvs.modules && sudo bash /etc/sysconfig/modules/ipvs.modules && sudo lsmod | grep -e ip_vs -e nf_conntrack_ipv4

# set /etc/hosts
sudo sh -c 'echo "192.168.5.56 nef-ci.com" >> /etc/hosts'
sudo sh -c 'echo "export PATH=/var/lib/rancher/rke2/bin:/usr/local/bin:\$PATH" >> /root/.bash_profile'
sudo sh -c 'echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml" >> /root/.bash_profile'
sudo sh -c 'echo "export CONTAINER_RUNTIME_ENDPOINT=unix:///run/k3s/containerd/containerd.sock" >> /root/.bash_profile'

# end of script.
