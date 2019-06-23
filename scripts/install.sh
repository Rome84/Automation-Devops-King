#!/bin/bash
set -x

TERRAFORM_VERSION="0.12.2"
PACKER_VERSION="0.10.2"

# create new ssh key
[[ ! -f /home/ubuntu/.ssh/mykey ]] \
&& mkdir -p /home/ubuntu/.ssh \
&& ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
&& chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# install packages
sudo apt-get -y update
sudo apt-get -y install docker.io ansible unzip

# add docker privileges
usermod -G docker ubuntu

# install pip
sudo pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi

# Install necessary dependencies
sudo apt-get -y -q install curl wget git tmux vim
sudo apt-get -y install zsh
#terraform
T_VERSION=$(terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(packer -v)
P_RETVAL=$?

# Install Packer
[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# Install Ansible 2.7
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible

# Install Kubernetes Kubctl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -y update && sudo apt-get upgrade
sudo apt-get -y install software-properties-common
sudo apt-get -y install -y kubectl
sudo apt update && sudo apt dist-upgrade
sudo apt-get -y install update-manager-core

# Install net-tools
sudo apt-get -y install net-tools
sudo apt-get -y install nmap

# Other Linux Fancy Stuff
sudo add-apt-repository ppa:dawidd0811/neofetch
sudo apt-get -y install neofetch
sudo apt-get -y install sysvbanner
sudo apt-get -y install linuxlogo

# Install Python3 and Boto
sudo apt-get -y install python3-pip -y
sudo python -m pip install boto3
sudo pip install --upgrade pip

# install awscli and ebcli
sudo pip3 install awscli --upgrade --user
sudo pip3 install awsebcli --upgrade --user

# Using APT you can install the tools with the following RPM packages
sudo apt-get -y install lsof*
sudo apt-get -y install iotop*
sudo apt-get -y install htop*
sudo apt-get -y install sysstat
sudo apt-get -y install toilet && sudo apt-get -y install figlet
sudo apt-get -y install tree

sudo echo 'echo "ROME WELCOME YOU TO THE WORLD OF DEVOPS"' >> ~/.bashrc

# clean up
sudo apt-get clean

sudo apt-get -y update 

