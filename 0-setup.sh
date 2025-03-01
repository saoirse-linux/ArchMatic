#!/usr/bin/env bash
#-------------------------------------------------------------------------
#         _          _    __  __      _   _
#        /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#       / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#      /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Saoirse Linux Post Arch Install Setup and Config
#-------------------------------------------------------------------------

source environment.sh

if ! source install.conf; then
	read -p "Please enter hostname: " hostname

	read -p "Please enter username: " username

	read -sp "Please enter password: " password

	read -sp "Please repeat password: " password2

	# Check both passwords match
	if [ "$password" != "$password2" ]; then
	    echo "Passwords do not match"
	    exit 1
	fi
  printf "hostname="$hostname"\n" >> "install.conf"
  printf "username="$username"\n" >> "install.conf"
  printf "password="$password"\n" >> "install.conf"
fi

# CHANGE THIS!
#echo "-------------------------------------------------"
#echo "Choose mirrors for optimal download."
#echo "-------------------------------------------------"
#pacman -S --noconfirm pacman-contrib curl
#mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
#curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have "$nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

echo "-------------------------------------------------"
echo "     Setup preferred language and it's locale    "
echo "-------------------------------------------------"
echo "Use 'cat /etc/locale-gen' to check for available values"
read -p "Type your locale:  "
echo "Changing locale"
sed -i 's/^#$LOCALE.UTF-8 UTF-8/$LOCALE.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#$LOCALE.ISO-8859-1 UTF-8/$LOCALE.ISO-8859-1 UTF-8/' /etc/locale.gen
locale-gen
# WIP! ls -R -w 1 -d */usr/share/zoneinfo/ | less 
echo "Type your timezone: "
# SET TIMEZONE FOR ARCH timedatectl --no-ask-password set-timezone America/Chicago
# SET TIMEZONE FOR ARCH timedatectl --no-ask-password set-ntp 1
# SET TIMEZONE FOR ARCH localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="$LOCALE.UTF-8"

# Set keymaps
# SET KEYTIMES FOR ARCH localectl --no-ask-password set-keymap us

# Hostname
# SET HOSTNAME FOR ARCH hostnamectl --no-ask-password set-hostname $hostname

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

