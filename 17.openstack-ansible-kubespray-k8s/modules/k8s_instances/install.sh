#!/bin/sh
USER=rocky
HOME=/home/$USER

# for log
export INSTALL_LOG=/var/log/k8s_install.log
sudo touch $INSTALL_LOG
sudo chown $USER $INSTALL_LOG

# net-tools ¼³Ä¡
sudo dnf -y install net-tools &>> $INSTALL_LOG

# [How to setup SCTP In Red Hat Enterprise Linux 8](https://access.redhat.com/solutions/6625041)
sudo dnf -y install kernel-modules-extra-`uname -r` &>> $INSTALL_LOG
sudo modprobe sctp &>> $INSTALL_LOG

# end of script.
