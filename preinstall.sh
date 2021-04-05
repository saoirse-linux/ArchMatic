#!/usr/bin/env bash
#---------------------------------------------------------
#           ____                 _
#          / ___|  ___  _ __ ___| |__   __ _
#          \___ \ / _ \| '__/ __| '_ \ / _` |
#           ___) | (_) | | | (__| | | | (_| |
#          |____/ \___/|_|  \___|_| |_|\__,_|
#
#    Saoirse Linux Post Arch Install Setup and Config
#---------------------------------------------------------

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download - US Only"
echo "-------------------------------------------------"
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist



echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo "--------------------------------------"

# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+1000M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
sgdisk -n 2:0:0     ${DISK} # partition 2 (Root), default start, remaining

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

# label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

# make filesystems
echo -e "\nCreating Filesystems...\n$HR"

mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"

# mount target
mkdir /mnt
mount -t ext4 "${DISK}2" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat "${DISK}1" /mnt/boot/

echo "---------------------------------------"
echo "--   Seoirse Install on Main Drive   --"
echo "---------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware neovim sudo --noconfirm --needed
fgenstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

echo "-------------------------------------"
echo "--  Bootloader Runit Installation  --"
echo "-------------------------------------"

cat <<EOF > /boot/loader/entries/arch.conf
title Saoirse Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=${DISK}1 rw
EOF

echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager dhcpcd --noconfirm --needed
sudo ln -s /etc/runit/sv/NetworkManager /run/runit/service

echo "--------------------------------------"
echo "--       Set Password for Root      --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd root

exit
umount -R /mnt

echo "--------------------------------------"
echo "--   SYSTEM READY FOR FIRST BOOT    --"
echo "--------------------------------------"
