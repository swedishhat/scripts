#!/bin/sh

echo "\n--- ROS Chroot Script ---"

# One time copying of files over if you add a user or something
: <<'BLOCK'
sudo cp /etc/resolv.conf /var/chroot/etc/resolv.conf
# sudo cp /etc/apt/sources.list /var/chroot/etc/apt/ # Probably don't run this if you have conflicting versions
sudo cp /etc/passwd /var/chroot/etc/
sudo sed 's/\([^:]*\):[^:]*:/\1:*:/' /etc/shadow | sudo tee /var/chroot/etc/shadow
sudo cp /etc/group /var/chroot/etc/
sudo cp /etc/hosts /var/chroot/etc/ # avoid sudo warnings when it tries to resolve the chroot's hostname
sudo cp /etc/sudoers /var/chroot/etc/

# For a new user, as root in the schroot environment:
    # dpkg-reconfigure passwd
    # passwd <username of your first ubuntu user in the admin group>

BLOCK

echo "\nMounting local file system folders to chroot"
sudo mount -o bind /proc /var/chroot/proc
sudo mount -o bind /home /var/chroot/home
sudo mount -o bind /sys /var/chroot/sys
sudo mount -o bind /dev /var/chroot/dev
sudo mount -o bind /tmp /var/chroot/tmp
sudo mount -o bind /var/run/dbus/ /var/chroot/var/run/dbus

echo "\nAllow chroot to connect to local X server"
xhost +

echo "\nEverything should be good to go. Logging you in as bot..."
echo "\nRemember to run \"export DISPLAY=:0.0\" \n"
cd /home/bot
#schroot -c precise -u bot sh -c "export DISPLAY=:0"
schroot -c precise -u bot
