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

# AUR

sudo pacman -S  base-devel git;
git clone https://aur.archlinux.org/yay.git ; ee $?
cd yay ; ee $?
makepkg -si ; ee $?

yay -Syu ; ee $?
# laptopmode

# curl -sSL https://gitlab.com/maxlofi/arch/-/raw/dev/start.sh | bash