#!/bin/sh
USER=rocky
HOME=/home/$USER

# for log
export INSTALL_LOG=/var/log/k8s_install.log
sudo touch $INSTALL_LOG
sudo chown $USER $INSTALL_LOG

sudo usermod -aG docker $USER &>> $INSTALL_LOG

# https://unix.stackexchange.com/questions/18897/problem-while-running-newgrp-command-in-script
/usr/bin/newgrp docker <<EONG
echo "hello from within newgrp"
id
EONG

mkdir -p $HOME/.kube &>> $INSTALL_LOG
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config &>> $INSTALL_LOG
sudo chown $(id -u):$(id -g) $HOME/.kube/config &>> $INSTALL_LOG
sed -i 's/127.0.0.1/'$(hostname -i)'/g' $HOME/.kube/config &>> $INSTALL_LOG
kubectl taint nodes --all node-role.kubernetes.io/control-plane- &>> $INSTALL_LOG
kubectl taint nodes --all node-role.kubernetes.io/master- &>> $INSTALL_LOG
kubectl get node -o wide &>> $INSTALL_LOG

# end of script.
