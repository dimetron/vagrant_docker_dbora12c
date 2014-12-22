#!/bin/bash -eux
#

echo "Check HDD"
ls /dev/sd*
mkfs.btrfs -f /dev/sdb
btrfs filesystem show

echo "Install Oracle UEK"
#yum install -y elfutils-libs kernel-uek-devel
#grubby --set-default=/boot/vmlinuz-3.8*

## upgrade to latest release
#echo "Upgrade to latest Linux version ..."
#yum upgrade -y
#reboot
