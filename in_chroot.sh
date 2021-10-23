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

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime ; ee $?
hwclock --systohc ; ee $?
sed -i '248s/.//' /etc/locale.gen ; ee $?
locale-gen ; ee $?
echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf ; ee $?
echo "KEYMAP=fr-latin9" >> /etc/vconsole.conf ; ee $?
echo "think" >> /etc/hostname ; ee $?
echo "127.0.0.1 localhost" >> /etc/hosts ; ee $?
echo "::1       localhost" >> /etc/hosts ; ee $?
echo "127.0.1.1 think.localdomain think" >> /etc/hosts ; ee $?

passwd root ; ee $?

pacman -S grub grub-btrfs efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld acpid os-prober ntfs-3g terminus-font ; ee $?

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB  ; ee $?
grub-mkconfig -o /boot/grub/grub.cfg  ; ee $?


systemctl enable NetworkManager  ; ee $?
systemctl enable sshd; ee $?
systemctl enable tlp; ee $?
systemctl enable reflector.timer; ee $?
systemctl enable fstrim.timer; ee $?
systemctl enable libvirtd; ee $?
systemctl enable firewalld; ee $?
systemctl enable acpid; ee $?

useradd -m max; ee $?
passwd max ; ee $?
usermod -aG libvirt max ; ee $?

echo "max ALL=(ALL) ALL" >> /etc/sudoers.d/max ; ee $?




sed -ie "s/MODULES=()/MODULES=(btrfs)/g" /ect/mkinitcpio.conf ; ee $?
sed -ie "s/block filesystems/block encrypt filesystems/g" /ect/mkinitcpio.conf ; ee $?

mkinitcpio -p linux ; ee $?



uuid=`ls -l /dev/disk/by-uuid/ | grep sda2 | cut -d " " -f 11` ; ee $?

plop="cryptdevice=UUID=$uuid:vault root=/dev/mapper/vault" ; ee $?


sed -ie "s|loglevel=3 quiet|loglevel=3 quiet $plop|g" /etc/default/grub ; ee $?


echo "END"

