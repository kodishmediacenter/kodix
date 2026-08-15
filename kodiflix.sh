#!/bin/bash

flatpak install flathub tv.kodi.Kodi
cd $HOME/.var/app/tv.kodi.Kodi
mv data data2
wget https://archive.org/download/data_20260815/data.zip
unzip data.zip
