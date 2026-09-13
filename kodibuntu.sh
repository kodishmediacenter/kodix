# progresso 1 "Atualizando o sistema"
sudo apt-get update -y && sudo apt-get upgrade -y

# progresso 2 "Instalando codecs extras"
sudo apt install ubuntu-restricted-extras -y

# progresso 3 "Instalando Flatpak e adicionando Flathub"
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# progresso 4 "Instalando apps Flatpak"
flatpak install flathub com.spotify.Client -y
flatpak install flathub net.waterfox.waterfox -y
flatpak install flathub tv.kodi.Kodi -y
flatpak install flathub com.stremio.Stremio -y
flatpak install flathub rocks.shy.VacuumTube -y 
flatpak install flathub io.github.kolunmi.Bazaar -y 

# Dando permissão full ao Kodi 
flatpak override tv.kodi.Kodi \
--filesystem=host \
--device=all \
--share=network \
--share=ipc

# Suporte a DVD
sudo apt install libdvd-pkg -y
sudo dpkg-reconfigure libdvd-pkg

# progresso 14 "Instalando curl"
sudo apt install curl -y

# progresso 15 "Instalando descompactadores"
sudo apt install arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar unace unzip xz-utils zip -y

# progresso 17 "Instalando cliente de Torrent (qBittorrent)"
sudo apt install qbittorrent -y

# progresso 18 "Instalando GParted"
sudo apt install gparted -y

# Instalando as Coisas facilitar minha vida 
sudo apt-get install mousepad -y

