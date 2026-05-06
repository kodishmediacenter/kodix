#!/bin/bash

echo "========================================="
echo "   Script Para Instalar Format Factory   "
echo "========================================="

echo "========================================="
echo     Instalando dependencias 
echo "========================================="

sudo pacman -S ffmpeg
sudo pacman -S x264 x265 lame libvpx

echo "========================================="
echo     Baixando Appimage
echo "========================================="

wget https://raw.githubusercontent.com/kodishmediacenter/kodix/refs/heads/main/appimage/FormatFactory-x86_64.AppImage
chmod +x FormatFactory-x86_64.AppImage
