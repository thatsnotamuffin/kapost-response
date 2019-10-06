#!/bin/bash

## This script is to setup the environment to ensure a smooth run
## Please read the README.md prior to running this script or starting the docker container

sudo yum update -y
sudo yum install -y python36
sudo yum install python36-setuptools
sudo easy_install-3.6 pip
sudo pip3 install awscli --upgrade
sudo yum install -y docker
sudo yum install -y git
sudo service docker start

printf "\n\n"
read -p "Enter the user you wish to add to the docker group: " username
sudo usermod -a -G docker $username
printf "\n\n"
echo "Please log off of $username and log back in, to ensure the group changes are complete.."
