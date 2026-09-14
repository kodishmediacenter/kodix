#!/bin/bash

flatpak install flathub tv.kodi.Kodi
cd $HOME/.var/app/tv.kodi.Kodi
mv data data2
wget https://archive.org/download/tv-eminem-3.0.1-32/TV-EMINEM-3.0.1-32.zip
mv TV-EMINEM-3.0.1-32.zip data.zip
unzip data.zip
