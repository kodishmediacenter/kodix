#!/bin/bash
echo "========================================================================================================="
echo "================ Script CA Microsoft 2023 by Sayro Digital =============================================="
echo "========================================================================================================="

echo "========================== Update Da Distro do Ubuntu ==================================================="
sudo apt update
sudo apt full-upgrade
echo "========================== Instalando as Deppendencias ==================================================="
sudo apt install golang-go git libpcsclite-dev -y
git clone https://github.com/Foxboron/sbctl.git
echo "========================== Instalando o Carimbo ==========================================================="
cd sbctl
go build ./cmd/sbctl
sudo mv sbctl /usr/local/bin/
sudo chmod +x /usr/local/bin/sbctl
cd ~
echo "==========================Verificando o Status ==========================================================="
sudo sbctl status
echo "==========================Criando novas Chaves ==========================================================="
sudo sbctl create-keys
echo "==========================Registrando Novas Chaves na EFI ================================================"
sudo sbctl enroll-keys -m
echo "==========================Verifica as Chaves que Necessita de Assinatura ================================="
sudo sbctl verify


echo "Escolha uma opção:"
echo "1) EFI Genérico"
echo "2) Ubuntu/Mint/Zorin"
read -rp "Opção: " opcao

case "$opcao" in
    1)
        sudo sbctl sign -s /boot/efi/EFI/BOOT/BOOTX64.EFI
        sudo sbctl sign -s /boot/efi/EFI/BOOT/fbx64.efi
        sudo sbctl sign -s /boot/efi/EFI/BOOT/mmx64.efi
        ;;
    2)
        sudo sbctl sign -s /boot/efi/EFI/ubuntu/grubx64.efi
        sudo sbctl sign -s /boot/efi/EFI/ubuntu/mmx64.efi
        sudo sbctl sign -s /boot/efi/EFI/ubuntu/shimx64.efi
        ;;
    *)
        echo "Opção inválida."
        exit 1
        ;;
esac

echo "Concluído."
