#!/bin/sh

# Step 1) install docker
sudo echo ">>> Step 1... install docker"
sudo apt-get update
sudo apt-get -y install docker.io

# Step 2) run rancher
sudo echo ">>> Step 2..."
sudo docker run \
  -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  --name rancher \
  rancher/rancher:latest
sudo sleep 10

# Step 3) get password
sudo echo ">>> Step 3..."
sudo sleep 30
sudo docker logs rancher 2>&1 | grep "Bootstrap Password:"
