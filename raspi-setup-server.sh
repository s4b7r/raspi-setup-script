#/bin/bash

echo "Name for new administrative user account: "
read adminname

source ./_raspi-setup--input.sh

echo "Adding admin user now. Please provide password when asked."
adduser --gecos "" $adminname
adduser $adminname sudo

source ./_raspi-setup--do.sh

systemctl enable ssh
systemctl start ssh

# disbale serial console
systemctl disable serial-getty@ttyAMA0.service
systemctl stop serial-getty@ttyAMA0.service

# disable auto-login
systemctl set-default graphical.target
ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
rm /etc/systemd/system/getty@tty1.service.d/autologin.conf
sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/#autologin-user=/"
#disable_raspi_config_at_boot

apt -y install ufw
systemctl enable ufw
ufw default deny incoming
ufw default deny outgoing
ufw limit ssh
ufw allow out http
ufw allow out https
ufw allow out 53
ufw allow ntp
ufw allow out ntp
ufw logging on
yes | ufw enable

# allow outbound icmp
sed -i "/^COMMIT$/ i # ... but first ... \\
# allow outbound icmp \\
-A ufw-before-output -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT \\
-A ufw-before-output -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT" /etc/ufw/before.rules
# service restart required?
#systemctl restart ufw

mv /etc/sudoers.d/010_pi-nopasswd /etc/sudoers.d/010_pi-nopasswd~
# reboot required?

passwd --lock pi
sed -i '/^hidden-users=/ s/$/ pi/' /etc/lightdm/users.conf

reboot
