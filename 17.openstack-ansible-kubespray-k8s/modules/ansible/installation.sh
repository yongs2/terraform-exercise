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
# sudo dnf -y update &>> $INSTALL_LOG
sudo dnf -y install epel-release &>> $INSTALL_LOG
sudo dnf -y install jq git gcc &>> $INSTALL_LOG
sudo dnf -y install python39-devel python3-pip &>> $INSTALL_LOG
sudo pip3.9 install yq &>> $INSTALL_LOG

### clone kubespray ###
echo start clone kubespray &>> $INSTALL_LOG
git clone -b ${kubespray_version} https://github.com/kubernetes-sigs/kubespray.git &>> $INSTALL_LOG
echo kubespray cloend. &>> $INSTALL_LOG

### [prepare kubespray](https://github.com/kubernetes-sigs/kubespray) ###
cd kubespray
sudo pip3.9 install ruamel_yaml &>> $INSTALL_LOG
sudo pip3.9 install -r requirements.txt &>> $INSTALL_LOG
cp -rfp inventory/sample inventory/mycluster

YAML_FILE="inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml"
echo "fix $YAML_FILE" &>> $INSTALL_LOG
# for docker
sed -i 's/resolvconf_mode: host_resolvconf/resolvconf_mode: docker_dns/g' $YAML_FILE
sed -i 's/container_manager: containerd/container_manager: docker/g' $YAML_FILE
# for metallb
sed -i 's/kube_proxy_strict_arp: false/kube_proxy_strict_arp: true/g' $YAML_FILE
# for network
sed -i 's/kube_service_addresses: 10.233.0.0\/18/kube_service_addresses: 10.96.0.0\/18/g' $YAML_FILE
sed -i 's/kube_pods_subnet: 10.233.64.0\/18/kube_pods_subnet: 10.32.0.0\/18/g' $YAML_FILE
# etc
# sed -i 's/kube_log_level: 2/kube_log_level: 0/g' $YAML_FILE
sed -i 's/kubernetes_audit: false/kubernetes_audit: true/g' $YAML_FILE

YAML_FILE="inventory/mycluster/group_vars/k8s_cluster/addons.yml"
echo "fix $YAML_FILE" &>> $INSTALL_LOG
sed -i 's/# dashboard_enabled: false/dashboard_enabled: true/g' $YAML_FILE
sed -i 's/helm_enabled: false/helm_enabled: true/g' $YAML_FILE
sed -i 's/metrics_server_enabled: false/metrics_server_enabled: true/g' $YAML_FILE
sed -i 's/metallb_enabled: false/metallb_enabled: true/g' $YAML_FILE
sed -i 's/# metallb_ip_range:/metallb_ip_range:/g' $YAML_FILE
sed -i 's/#   - \"10.5.0.50-10.5.0.99\"/   - \"'${metallb_ip_range}'\"/g' $YAML_FILE
sed -i 's/# metallb_pool_name: \"loadbalanced\"/metallb_pool_name: \"loadbalanced\"/g' $YAML_FILE
sed -i 's/# metallb_protocol: \"layer2\"/metallb_protocol: \"layer2\"/g' $YAML_FILE

YAML_FILE="inventory/mycluster/group_vars/all/etcd.yml"
echo "fix $YAML_FILE" &>> $INSTALL_LOG
# for docker
sed -i 's/# container_manager: containerd/container_manager: docker/g' $YAML_FILE
sed -i 's/etcd_deployment_type: host/etcd_deployment_type: docker/g' $YAML_FILE

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
-e auto_renew_certificates=true \
-b cluster.yml" > install.sh
chmod +x install.sh

### print Guidelines ###
echo to beginning of installation run: /home/$User_Name/kubespray/install.sh &>> $INSTALL_LOG
echo 'initialization finished' &>> $INSTALL_LOG
echo '#################' &>> $INSTALL_LOG
echo '/home/$User_Name/kubespray/install.sh started...' &>> $INSTALL_LOG
/home/$User_Name/kubespray/install.sh &>> $INSTALL_LOG
