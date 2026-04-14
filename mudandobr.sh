#!/bin/bash

echo "====================================="
echo "   Mudando Repo Oficial para Brasil  "
echo "====================================="

# Set Mirror para Brasil 
sudo pacman -S --noconfirm reflector

echo Aplicando configuração para Brasil 
sudo reflector --country Brazil --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo Atualizando repositorios
sudo pacman -Syy
