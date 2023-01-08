#!/bin/sh
apt-get update -y && apt-get upgrade -y 
apt-get install wget curl xz-utils -y
mkdir Proot
cd Proot
wget https://uk.lxd.images.canonical.com/images/ubuntu/focal/amd64/cloud/20230107_07:42/rootfs.tar.xz && tar -xf rootfs.tar.xz && rm -rf rootfs.tar.xz
wget https://raw.githubusercontent.com/314257smcag2/VPSMG0/main/VSCODETOr.sh
wget https://proot.gitlab.io/proot/bin/proot && chmod +x proot
./proot -S . chmod +x VSCODETOr.sh
./proot -S . sudo su -c "./VSCODETOr.sh"
