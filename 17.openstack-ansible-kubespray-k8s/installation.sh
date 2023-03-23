#!/bin/bash

# current directory=/, ID=uid=0(root)

#CONFIG_FILE is address of ansible inventory file
export CONFIG_FILE=inventory/mycluster/hosts.yaml
#USE_REAL_HOSTNAME is switch to detect real hostname by inventory.py
export USE_REAL_HOSTNAME=true
#KUBE_MASTERS is total count of masters in inventory file
#export KUBE_MASTERS=3
export User_Name=rocky

# for log
export INSTALL_LOG=/var/log/k8s_install.log
sudo touch $INSTALL_LOG
sudo chown $User_Name $INSTALL_LOG

### add private ssh key ###
touch /home/$User_Name/.ssh/id_rsa
chmod 600 /home/$User_Name/.ssh/id_rsa
echo "${private_key}" > /home/$User_Name/.ssh/id_rsa
chown $User_Name /home/$User_Name/.ssh/id_rsa

### install Prerequisite ###
echo "current directory=$PWD, ID=$(id)" &>> $INSTALL_LOG
sudo dnf -y update &>> $INSTALL_LOG
sudo dnf -y install epel-release &>> $INSTALL_LOG
sudo dnf -y install jq git gcc &>> $INSTALL_LOG
sudo dnf -y install python39-devel python3-pip &>> $INSTALL_LOG
sudo pip3.9 install yq &>> $INSTALL_LOG

### clone kubespray ###
echo start clone kubespray &>> $INSTALL_LOG
git clone https://github.com/kubernetes-sigs/kubespray.git &>> $INSTALL_LOG
echo kubespray cloend. &>> $INSTALL_LOG

### [prepare kubespray](https://github.com/kubernetes-sigs/kubespray) ###
cd kubespray
sudo pip3.9 install ruamel_yaml &>> $INSTALL_LOG
sudo pip3.9 install -r requirements.txt &>> $INSTALL_LOG
cp -rfp inventory/sample inventory/mycluster

### fix kubespray master worker separation bug ###
sed -i '369s/SCALE_THRESHOLD/0/' contrib/inventory_builder/inventory.py

### create ansible inventroy ###
export KUBE_CONTROL_HOSTS=${kube_control_hosts}
echo "create ansible inventroy master.cnt(${kube_control_hosts})=${masterips}, worker=${workerips}" &>> $INSTALL_LOG
python3.9 contrib/inventory_builder/inventory.py ${masterips} &>> $INSTALL_LOG
python3.9 contrib/inventory_builder/inventory.py add ${workerips} &>> $INSTALL_LOG
echo "check $CONFIG_FILE" && cat $CONFIG_FILE &>> $INSTALL_LOG

### create install.sh script ###
echo "create install.sh script" &>> $INSTALL_LOG
echo "ansible_ssh_common_args=-o \
StrictHostKeyChecking=no \
ansible-playbook -i inventory/mycluster/hosts.yaml \
-e ansible_user=$User_Name \
-e https_proxy=${http_proxy} \
-e http_proxy=${http_proxy} \
-e metrics_server_enabled=true \
-e ingress_nginx_enabled=true \
-e auto_renew_certificates=true \
-b cluster.yml" > install.sh
chmod +x install.sh

### print Guidelines ###
echo to beginning of installation run: /home/$User_Name/kubespray/install.sh &>> $INSTALL_LOG
echo 'initialization finished' &>> $INSTALL_LOG
echo '#################' &>> $INSTALL_LOG
echo '/home/$User_Name/kubespray/install.sh started...' &>> $INSTALL_LOG
/home/$User_Name/kubespray/install.sh &>> $INSTALL_LOG
