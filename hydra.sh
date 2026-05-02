#!/bin/bash
wget https://github.com/hydralauncher/hydra/releases/download/v3.9.7/hydralauncher-3.9.7.AppImage
mkdir /kodish/appimage &
thunar /kodish/appimage &
flatpak run it.mijorus.gearlever &
