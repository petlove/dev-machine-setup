#!/bin/bash

# This script is run on the live usb drive.

set -e

DISK="nvme0n1"

# Inspired by:
# https://www.youtube.com/watch?v=oKnkOwdysNs

# Ensure to run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script only works as root, access it using: 'sudo su'"
  exit 1
fi

# Install dependecies
apt update
apt install -y \
  debootstrap \
  dosfstools

echo "Deleting existing partitions on $DISK"
sfdisk --delete /dev/$DISK

# Partioning disk
(
echo g     # create a gpt disk label

echo n     # add partition for boot
echo       # default
echo       # default
echo +512M # 512MB
echo t     # change type
echo 1     # EFI System

echo n     # add swap partition
echo       # default
echo       # default
echo +16G  # 16GB of SWAP
echo t     # change type
echo       # default
echo 19    # swap type

echo n     # add main partition using remaining of disk
echo       # default
echo       # default
echo       # default
echo w     # writes partitions to disk

) | fdisk -w never -W never /dev/$DISK


# Create filesystems
mkfs.vfat /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 -F /dev/nvme0n1p3

# Mount partition where system is going go be installed on /mnt
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

# Install bookworm on /mnt
debootstrap bookworm /mnt

# Mount
for dir in sys dev proc
do
  mount --rbind /$dir /mnt/$dir && mount --make-rslave /mnt/$dir
done

# Copy resolv.conf
cp /etc/resolv.conf /mnt/etc/resolv.conf

# Creating fstab
apt install -y arch-install-scripts
swapon /mnt/dev/nvme0n1p2
genfstab -U /mnt > /mnt/etc/fstab
swapoff /mnt/dev/nvme0n1p2

# Copies file to mounted partition so it doesn't need to be cloned again
cp 02-bootstrap-chroot.sh /mnt/tmp

# Accessing the new installation
chroot /mnt /bin/bash
