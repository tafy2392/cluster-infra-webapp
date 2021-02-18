#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

# Install package for upgrades
sudo apt-get install curl

# install docker as the container runtine engine
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh 

systemctl start docker 2>&1

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update

sudo apt-get install -y \
kubelet=${kubernetes_version}-00 \
kubeadm=${kubernetes_version}-00 \
kubectl=${kubernetes_version}-00

# Hold kubernetes
sudo apt-mark hold kubelet kubeadm kubectl

kubeadm init

# By now the master node should be ready!
mkdir -p $HOME/.kube
sudo cp --remove-destination /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install weavenet
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Wait everything to become ready
sleep 40

# Make master node a running worker node too!
# FIXME: Use taint tolerations instead in the future
kubectl taint nodes --all node-role.kubernetes.io/master-

# create ns  for argocd
kubectl create ns argocd
kubectl apply -k github.com/tafy2392/core-infra-kubernetes?ref=master
