#!/bin/bash

# kubernetes를 사용하기 위한 사전 세팅
export INSTALL_LOG=/var/log/k8s_install.log
echo "START SCRIPT >>>>>>> INSTALL_LOG=${INSTALL_LOG}, HOME=${HOME}"
sudo touch $INSTALL_LOG
sudo chown $USER $INSTALL_LOG

echo "wait a moment, sleep 10s"
sleep 10

# apt 패키지 업데이트
echo ">> upgrade"
sudo apt-get -y upgrade &>> $INSTALL_LOG
sudo apt-get -y update  &>> $INSTALL_LOG
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release net-tools jq &>> $INSTALL_LOG

# swap disable
sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

# docker 설치
echo ">> install docker"
## Docker 공식 GPG key 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &>> $INSTALL_LOG
## Docker를 stable 버전으로 설치하기 위한 명령어 실행
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &>> $INSTALL_LOG
## Docker 엔진 설치
sudo apt-get -y update &>> $INSTALL_LOG
sudo apt-get -y install docker-ce docker-ce-cli containerd.io &>> $INSTALL_LOG
## daemon.json 설정
sudo mkdir -p /etc/docker
echo '{"exec-opts": ["native.cgroupdriver=systemd"],"log-driver":"json-file","log-opts": {"max-size":"100m"},"storage-driver":"overlay2"}' | sudo tee /etc/docker/daemon.json &>> $INSTALL_LOG
## Docker 서비스 등록 및 실행
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker && sudo systemctl start docker &>> $INSTALL_LOG

# kubernetes 설치
echo ">> install kubelet,kubeadm,kubectl"
## 구글 클라우드 public key 다운로드
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - &>> $INSTALL_LOG
## kubernetes 저장소 추가
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null &>> $INSTALL_LOG
## 저장소 업데이트 및 kubelet, kubeadm, kubectl 설치
sudo apt-get -y update &>> $INSTALL_LOG
## 저장소 업데이트 및 kubelet, kubeadm, kubectl 설치
sudo apt-get -y install kubelet kubeadm kubectl &>> $INSTALL_LOG
sudo apt-mark hold kubelet kubeadm kubectl &>> $INSTALL_LOG
sudo /bin/rm -f /etc/containerd/config.toml
## kubernetes 서비스 등록 및 실행
sudo systemctl restart containerd &>> $INSTALL_LOG
sudo systemctl enable kubelet &>> $INSTALL_LOG
sudo systemctl restart kubelet &>> $INSTALL_LOG

echo ">> images pull"
sudo kubeadm config images pull &>> $INSTALL_LOG
