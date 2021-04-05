# Saoirse ArchMatic Installer Script

<img src="https://i.imgur.com/Yn29sze.png" />

This README contains the steps needed to install and configure a Saoirse Linux installation containing a window manager, all the support packages (network, bluetooth, audio, etc.). The shell scripts in this repo allow the entire process to be automated.)
Through the process of learning we will eventually make a distro from scratch and mantain it, but it will take a long time. Any help and support will be appreciated!

---

## Setup Boot and Artix ISO on USB key

First, setup the boot USB, boot Artix Live ISO, and run the `preinstall.sh` from terminal. 

### Artix Live ISO (Pre-Install)

This step installs arch to your hard drive. *IT WILL FORMAT THE DISK*

```bash
wget https://raw.githubusercontent.com/saoirse-linux/ArchMatic/master/preinstall.sh
sh preinstall.sh
reboot
```

### Artix Linux First Boot

```bash
pacman -S --no-confirm pacman-contrib curl git
git clone https://github.com/saoirse-linux/ArchMatic
cd ArchMatic
./0-setup.sh
./1-base.sh
./2-software-pacman.sh
./3-software-aur.sh
./4-post-setup.sh
```

### Don't just run these scripts. Examine them. Customize them. Create your own versions.

---

### System Description
This runs Awesome Window Manager with the base configuration from the Material-Awesome project <https://github.com/ChrisTitusTech/material-awesome>.

To boot I use `systemd` because it's minimalist, comes built-in, and since the Linux kernel has an EFI image, all we need is a way to execute it.

I also install the LTS Kernel along side the rolling one, and configure my bootloader to offer both as a choice during startup. This enables me to switch kernels in the event of a problem with the rolling one.

### Troubleshooting Artix Linux

__[Arch Linux Installation Gude](https://github.com/rickellis/Arch-Linux-Install-Guide)__

#### No Wifi

```bash
sudo wifi-menu`
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```
