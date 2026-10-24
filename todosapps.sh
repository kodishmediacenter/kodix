wget https://raw.githubusercontent.com/kodishmediacenter/BC-Men8/refs/heads/main/todos-os-apps.desktop
wget https://raw.githubusercontent.com/kodishmediacenter/BC-Men8/refs/heads/main/todos-os-apps.py
wget https://raw.githubusercontent.com/kodishmediacenter/BC-Men8/refs/heads/main/todos-os-apps.svg

sudo pacman -S pyside6
mkdir -p ~/.local/bin ~/.local/share/applications
cp todos-os-apps.py ~/.local/bin/
chmod +x ~/.local/bin/todos-os-apps.py
cp todos-os-apps.desktop ~/.local/share/applications/

mkdir -p ~/.local/share/icons/hicolor/scalable/apps
cp todos-os-apps.svg ~/.local/share/icons/hicolor/scalable/apps/
cp todos-os-apps.desktop ~/.local/share/applications/
gtk-update-icon-cache -f ~/.local/share/icons/hicolor 2>/dev/null
kbuildsycoca6 2>/dev/null
