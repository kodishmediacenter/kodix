# Set Mirror para Brasil 
sudo pacman -S --noconfirm reflector
sudo reflector --country Brazil --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
