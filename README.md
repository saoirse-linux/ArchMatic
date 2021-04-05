# Saoirse ArchMatic Installer Script

This README contains the steps needed to install and configure a Saoirse Linux installation containing a window manager, all the support packages (network, bluetooth, audio, etc.). The shell scripts in this repo allow the entire process to be automated.) Open-RC support won't be given until we experience it.
Through the process of learning we will eventually make a distro from scratch and mantain it, but it will take a long time. Any help and support will be appreciated!

---

## Setup Boot and Artix ISO on USB key

First, setup the boot USB, boot Artix Live ISO, and run the `preinstall.sh` from terminal. 

### Artix Live ISO (Pre-Install)

This step installs Artix to your hard drive. *IT WILL FORMAT THE DISK*

```bash
wget https://raw.githubusercontent.com/saoirse-linux/Sorcha/master/preinstall.sh
sh preinstall.sh
reboot
```

### Artix Linux First Boot

```bash
pacman -S --no-confirm curl git
git clone https://github.com/saoirse-linux/Sorcha
cd Sorcha
./0-setup.sh
./1-base.sh
./2-software-pacman.sh
./3-software-aur.sh
./4-post-setup.sh
```

### Don't just run these scripts. Examine them. Customize them. Create your own versions. Soon we will create a fully deploy-automated branch.

---

### System Description
This runs the Suckless DWM (Dynamic window manager)

To boot GRUB is used paired to the runit/OpenRC init system.

As kernel we use XanMod Stable Real-time, we will test if a fully debloated version would offer a 'Plug and Play' experience. If not, then we will include a more overloaded kernel, but still kipping it minimalistic the best we can.

### Troubleshooting Artix Linux

#### As this is based on Artix for now, the official wiki can be fully applied. Excluding some systemd fixes published on the Arch Wiki, most of it can be modified and applied to this installation.

__[Artix Linux Installation Guide](https://wiki.artixlinux.org/Main/Installation)__

__[Artix Wiki](https://wiki.artixlinux.org/)__

__[Arch Wiki](https://wiki.archlinux.org/)__

#### Soon we will create a whole document on troubleshooting as well one about software recommendations based on personal experiences.

#### Wifi card selection

```bash
sudo wifi-menu
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```
