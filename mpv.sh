
#!/bin/bash

echo "Selecione sua distribuição Linux:"
echo "1) Arch Linux / Kodish OS"
echo "2) Ubuntu / Debian"
echo "3) Fedora"
echo "4) openSUSE"
echo "5) Sair"

select distro in "Arch/Kodish" "Ubuntu/Debian" "Fedora" "openSUSE" "Sair"; do
    case "$distro" in
        "Arch/Kodish")
            sudo pacman -S mpv
            break
            ;;
        "Ubuntu/Debian")
            sudo apt-get update
            sudo apt-get install mpv
            break
            ;;
        "Fedora")
            sudo dnf install mpv
            break
            ;;
        "openSUSE")
            sudo zypper install mpv
            break
            ;;
        "Sair")
            echo "Instalação cancelada."
            break
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
