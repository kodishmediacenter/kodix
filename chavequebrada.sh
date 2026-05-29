#!/bin/bash

KEY="915585A1C36690B1"

echo "==> Importando chave GPG..."
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys "$KEY"

if [ $? -ne 0 ]; then
    echo "Erro ao baixar chave GPG!"
    exit 1
fi

echo "==> Adicionando chave ao pacman-key..."
gpg --export --armor "$KEY" | sudo pacman-key --add -

echo "==> Assinando chave localmente..."
sudo pacman-key --lsign-key "$KEY"

echo "==> Atualizando keyring..."
sudo pacman-key --populate archlinux

echo "==> Tudo pronto!"
echo "Agora execute:"
echo "makepkg -si"
