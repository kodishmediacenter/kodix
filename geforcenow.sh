
echo "Fazendo o Download [1/4]"
wget https://international.download.nvidia.com/GFNLinux/GeForceNOWSetup.bin
echo "Aplicando Permissões [2/4]"
chmod +x GeForceNOWSetup.bin
echo "Instalando e Finalizando a Instalação [3/4]"
./GeForceNOWSetup.bin
echo "Instalação Concluida Removendo o arquivo de Instalação [4/4]"
rm -r GeForceNOWSetup.bin
