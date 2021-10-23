#!/bin/bash


RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
col=`tput cols`

ee (){
if [ $1 -eq 0 ]
then
    printf '%s%*s%s' "$GREEN" $col "[ OK ]" "$NORMAL"
else
  printf '%s%*s%s' "$RED" $col "[ FAIL ]" "$NORMAL"
  read aa
  exit 1
fi
}


loadkeys fr; ee $?

sgdisk -Z /dev/sda ; ee $? 
umount -f /dev/sda1

sgdisk -n1:2048:500M -t1:ef00 -c1:BOOT  /dev/sda ; ee $?
sgdisk -n2:+0:-0 -t2:8300 -c2:racine /dev/sda ; ee $?

partprobe /dev/sda
sgdisk /dev/sda -p ; ee $?
sleep 1

mkfs.vfat -F32 -n BOOT /dev/sda1 ; ee $?

cryptsetup luksFormat /dev/sda2 ; ee $?

cryptsetup luksOpen /dev/sda2 vault ; ee $?

mkfs.btrfs /dev/mapper/vault; ee $?

mount /dev/mapper/vault /mnt; ee $?
btrfs subvolume create /mnt/@; ee $?
btrfs subvolume create /mnt/@home; ee $?

umount /mnt ; ee $?

mount -o noatime,compress=zstd,space_cache,discard=async,subvol=@ /dev/mapper/vault /mnt; ee $?
mkdir /mnt/home; ee $?
mount -o noatime,compress=zstd,space_cache,discard=async,subvol=@home /dev/mapper/vault /mnt/home; ee $?
mkdir /mnt/boot; ee $?

mount /dev/sda1 /mnt/boot; ee $?



pacstrap /mnt linux linux-firmware base base-devel btrfs-progs intel-ucode vim ; ee $?
genfstab -U /mnt >> /mnt/etc/fstab ; ee $?

echo "arch-chroot /mnt/" ; ee $?

