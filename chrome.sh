# Script para instalar 
flatpak install flathub com.google.Chrome

# Correção google chrome  
flatpak override --user com.google.Chrome --filesystem=xdg-download
flatpak override --user com.google.Chrome --filesystem=home
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-gtk
flatpak override --user com.google.Chrome --filesystem=home
systemctl --user status xdg-desktop-portal
systemctl --user restart xdg-desktop-portal
