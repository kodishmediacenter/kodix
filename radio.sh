mkdir /kodish/scripts/radio
cd /kodish/scripts/radio

wget https://raw.githubusercontent.com/kodishmediacenter/appskodish/refs/heads/main/radio/radio.py
pip install python-vlc --break-system-packages
wget https://raw.githubusercontent.com/kodishmediacenter/appskodish/main/radio/estacoes_radio.m3u

echo "alias radio='python /kodish/scripts/radio/radio.py'" >> /home/kodish/.bashrc
