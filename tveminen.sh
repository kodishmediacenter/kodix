#!/bin/bash

flatpak install flathub tv.kodi.Kodi
cd $HOME/.var/app/tv.kodi.Kodi
mv data data2
mkdir data
cd data
wget https://archive.org/download/tv-eminem-3.0.1-32/TV-EMINEM-3.0.1-32.zip
rm -r *.zip
mv TV-EMINEM-3.0.1-32.zip data.zip
unzip data.zip
