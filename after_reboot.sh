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


sudo timedatectl set-ntp true ; ee $?
sudo hwclock --systohc ; ee $?
sudo reflector -c France -a 12 --sort rate --save /etc/pacman.d/mirrorlist ; ee $?

sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings i3 dmenu i3status xfce4-terminal brightnessctl; ee $?

#cp /etc/i3status.conf ~/.config/i3status/config ; ee $?
sudo systemctl enable lightdm; ee $?

echo "REBOOT"
