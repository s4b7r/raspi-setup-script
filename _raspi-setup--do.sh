#!/bin/bash

apt update
apt upgrade

echo "XKBMODEL=pc105" > /etc/default/keyboard
echo "XKBLAYOUT=de" > /etc/default/keyboard
echo "XKBVARIANT=nodeadkeys" > /etc/default/keyboard
echo "XKBOPTIONS=" > /etc/default/keyboard
setupcon
# reboot required for X to apply config

echo $newhostname > /etc/hostname
# reboot required (or service restart?)

# install vim, not only vi, for arrow key support
apt update
apt -y install vim

swapoff --all
apt -y remove dphys-swapfile
# reboot required?

cd /home/pi
git clone https://github.com/azlux/log2ram.git
cd log2ram
chmod +x install.sh
./install.sh
sed -i '/SIZE=40M/c\SIZE=128M' /etc/log2ram.conf
# reboot required

echo "tmpfs    /tmp    tmpfs    defaults,noatime,nodev,nosuid,size=100m    0 0" >> /etc/fstab
echo "tmpfs /var/tmp tmpfs defaults,noatime,nodev,nosuid,size=50M 0 0" >> /etc/fstab
# reboot required
