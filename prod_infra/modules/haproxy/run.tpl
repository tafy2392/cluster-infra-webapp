#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

# Install package for upgrades
sudo apt-get install curl

sudo apt-get install haproxy -y

apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install certbot -y
