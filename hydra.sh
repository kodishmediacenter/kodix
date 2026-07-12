#!/bin/bash
# Hydra Installer — https://hydralauncher.gg/install.sh
# Installs Hydra Game Launcher on Linux

set -e

BOLD=$'\033[1m'
DIM=$'\033[2m'
RESET=$'\033[0m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
TEAL=$'\033[0;36m'
BTEAL=$'\033[1;36m'
BWHITE=$'\033[1;37m'

OK="${GREEN}✓${RESET}"
GO="${TEAL}›${RESET}"
DOT="${TEAL}·${RESET}"
FAIL="${RED}✗${RESET}"

INSTALL_DIR="$HOME/.local/bin"
APPIMAGE_PATH="$INSTALL_DIR/hydra.AppImage"
WRAPPER_PATH="$INSTALL_DIR/hydra"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/hydra.desktop"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
ICON_PATH="$ICON_DIR/hydra.png"

GITHUB_API="https://api.github.com/repos/hydralauncher/hydra/releases/latest"
ICON_URL="https://raw.githubusercontent.com/hydralauncher/hydra/main/resources/icon.png"

# ─── Visuals ─────────────────────────────────────────────────────────────────

# Hydra says something in a speech bubble beside the logo.
# All logo lines are exactly 28 display chars wide.
hydra_say() {
  local bw=36 i
  local sep=""
  for ((i=0; i<bw; i++)); do sep="${sep}─"; done

  local -a logo=(
    '         █        █         '
    '          ███  ███          '
    '    █    ██████████    █    '
    '  █████ ████████████ █████  '
    ' ██   ██ ██████████ ██   ██ '
    '  ███   ████████████   ███  '
    '  ██████   ██████   ██████  '
    ' ██     ██ ██████ ██     ██ '
    '  █   █   ████████   █   █  '
    '   ████ ███      ███ ████   '
    '       ██   █  █   ██       '
    '        █████  █████        '
  )

  # Build bubble: top border, blank, message lines, blank, bottom border
  local -a bub=()
  bub+=("╭${sep}╮")
  bub+=("│$(printf '%*s' $bw '')│")
  for line in "$@"; do
    bub+=("│  $(printf '%-*s' $((bw - 2)) "$line")│")
  done
  bub+=("│$(printf '%*s' $bw '')│")
  bub+=("╰${sep}╯")

  local lh=${#logo[@]}   # 12
  local bh=${#bub[@]}

  # Center bubble against logo midpoint (row 5 of 0–11)
  local bub_start=$(( 5 - bh / 2 ))
  [ $bub_start -lt 0 ] && bub_start=0

  # Connector arrow at the vertical midpoint of the bubble
  local conn_row=$(( bh / 2 ))

  echo ""
  for ((i=0; i<lh; i++)); do
    local bub_i=$(( i - bub_start ))
    if [ $bub_i -ge 0 ] && [ $bub_i -lt $bh ]; then
      local conn="  "
      [ $bub_i -eq $conn_row ] && conn="╾─"
      # logo line + 2 spaces padding (28+2=30 col) + connector + bubble line
      printf "${BWHITE}%s  ${RESET}${BTEAL}%s${RESET}%s\n" \
        "${logo[$i]}" "$conn" "${bub[$bub_i]}"
    else
      printf "${BWHITE}%s${RESET}\n" "${logo[$i]}"
    fi
  done
  echo ""
}

divider() {
  echo -e "  ${DIM}────────────────────────────────────────────────────${RESET}"
}

ok()   { echo -e "  ${OK} ${GREEN}$1${RESET}"; }
warn() { echo -e "  ${DOT} ${YELLOW}$1${RESET}"; }
fail() { printf "\r  ${FAIL} ${RED}%s${RESET}%-40s\n" "$1" " "; exit 1; }

# Cycles spinner through task labels; prints one ✓ when all done
run_phase() {
  local done_label="$1"; shift
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  for task in "$@"; do
    local end=$((SECONDS + 1))
    while [ $SECONDS -lt $end ]; do
      for frame in "${frames[@]}"; do
        printf "\r  ${TEAL}%s${RESET} ${BOLD}%-44s${RESET}" "$frame" "$task"
        sleep 0.08
      done
    done
  done
  printf "\r  ${OK} ${GREEN}%s${RESET}%-42s\n" "$done_label" " "
}

# Runs a real command in background with spinner
run_cmd() {
  local label="$1"; shift
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  "$@" &>/dev/null &
  local pid=$!
  while kill -0 "$pid" 2>/dev/null; do
    for frame in "${frames[@]}"; do
      printf "\r  ${TEAL}%s${RESET} ${BOLD}%-44s${RESET}" "$frame" "$label"
      sleep 0.08
    done
  done
  if wait "$pid"; then
    printf "\r  ${OK} ${GREEN}%s${RESET}%-42s\n" "$label" " "
  else
    printf "\r  ${FAIL} ${RED}%s — failed${RESET}%-30s\n" "$label" " "
    exit 1
  fi
}

# Downloads a file with a real progress bar driven by live file size
download_file() {
  local url="$1" dest="$2" label="$3"
  local bar_width=28 i

  local size
  size=$(curl -sI -L "$url" | grep -i '^content-length:' | tail -1 | tr -d '\r' | awk '{print $2}')
  size="${size:-0}"

  curl -fsSL -o "$dest" "$url" &
  local pid=$!

  while kill -0 "$pid" 2>/dev/null; do
    local downloaded=0
    [ -f "$dest" ] && downloaded=$(stat -c%s "$dest" 2>/dev/null || echo 0)

    local filled=0 pct=0
    if [ "${size}" -gt 0 ] 2>/dev/null; then
      filled=$(( downloaded * bar_width / size ))
      pct=$(( downloaded * 100 / size ))
      [ $filled -gt $bar_width ] && filled=$bar_width
      [ $pct -gt 100 ] && pct=100
    fi

    local bar=""
    for ((i=0; i<filled; i++));        do bar="${bar}${TEAL}▪${RESET}"; done
    for ((i=filled; i<bar_width; i++)); do bar="${bar} "; done

    printf "\r  ${GO} ${BOLD}%s${RESET} [%s] %3d%%" "$label" "$bar" "$pct"
    sleep 0.1
  done

  if wait "$pid"; then
    local full_bar=""
    for ((i=0; i<bar_width; i++)); do full_bar="${full_bar}${TEAL}▪${RESET}"; done
    printf "\r  ${OK} ${GREEN}%s${RESET} [%s] 100%%\n" "$label" "$full_bar"
  else
    printf "\r  ${FAIL} ${RED}Download failed${RESET}%-30s\n" " "
    exit 1
  fi
}

# ─── Pre-flight ──────────────────────────────────────────────────────────────

[ "$(uname -s)" = "Linux" ]  || { echo -e "${FAIL} This script only supports Linux."; exit 1; }
[ "$(uname -m)" = "x86_64" ] || { echo -e "${FAIL} Only x86_64 is supported (got $(uname -m))."; exit 1; }
command -v curl &>/dev/null   || { echo -e "${FAIL} curl is required but not installed."; exit 1; }

hydra_say \
  "The definitive game launcher" \
  "for the 21st century." \
  "hydralauncher.gg"

divider
echo ""

# ─── Detect package manager ──────────────────────────────────────────────────

if command -v apt &>/dev/null; then   PKG_MGR="apt"
elif command -v dnf &>/dev/null; then PKG_MGR="dnf"
elif command -v yum &>/dev/null; then PKG_MGR="yum"
else                                  PKG_MGR="appimage"
fi

# ─── Fetch latest release ────────────────────────────────────────────────────

printf "  ${TEAL}⠋${RESET} ${BOLD}%-44s${RESET}" "Checking for the latest release..."
RELEASE_JSON=$(curl -sf "$GITHUB_API") || fail "Could not reach GitHub API"
VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | cut -d'"' -f4)
printf "\r  ${OK} ${GREEN}Hydra %s is available${RESET}%-20s\n" "$VERSION" " "

case "$PKG_MGR" in
  apt)
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep '"browser_download_url"' | grep 'amd64\.deb"' | cut -d'"' -f4)
    DOWNLOAD_FILE="/tmp/hydra_${VERSION}_amd64.deb"
    ;;
  dnf|yum)
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep '"browser_download_url"' | grep 'x86_64\.rpm"' | cut -d'"' -f4)
    DOWNLOAD_FILE="/tmp/hydra_${VERSION}_x86_64.rpm"
    ;;
  *)
    DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep '"browser_download_url"' | grep '\.AppImage"' | cut -d'"' -f4)
    DOWNLOAD_FILE="$APPIMAGE_PATH"
    ;;
esac

[ -n "$DOWNLOAD_URL" ] || fail "No download URL found for ${VERSION}"

echo ""

# ─── System checks ───────────────────────────────────────────────────────────

FREE_MB=$(df -m "$HOME" | awk 'NR==2 {print $4}')
[ "${FREE_MB:-0}" -gt 500 ] || fail "Need ~500 MB free (have ${FREE_MB} MB)"

run_phase "Everything looks good!" \
  "Scanning your environment" \
  "Verifying dependencies" \
  "Checking available storage"

echo ""
divider
echo ""

# ─── Download ────────────────────────────────────────────────────────────────

[ "$PKG_MGR" = "appimage" ] && mkdir -p "$INSTALL_DIR"

download_file "$DOWNLOAD_URL" "$DOWNLOAD_FILE" "Hydra ${VERSION}"

echo ""

# ─── Install ─────────────────────────────────────────────────────────────────

if [ "$PKG_MGR" != "appimage" ]; then
  sudo -v || fail "Administrator privileges are required"
fi

case "$PKG_MGR" in
  apt)
    run_cmd "Installing via apt" sudo apt install -y "$DOWNLOAD_FILE"
    rm -f "$DOWNLOAD_FILE"
    ;;
  dnf)
    run_cmd "Installing via dnf" sudo dnf install -y "$DOWNLOAD_FILE"
    rm -f "$DOWNLOAD_FILE"
    ;;
  yum)
    run_cmd "Installing via yum" sudo yum install -y "$DOWNLOAD_FILE"
    rm -f "$DOWNLOAD_FILE"
    ;;
  appimage)
    chmod +x "$APPIMAGE_PATH"

    cat > "$WRAPPER_PATH" <<WRAPPER
#!/bin/bash
exec "$APPIMAGE_PATH" "\$@"
WRAPPER
    chmod +x "$WRAPPER_PATH"

    mkdir -p "$ICON_DIR" "$DESKTOP_DIR"
    run_cmd "Fetching app icon" curl -fsSL -o "$ICON_PATH" "$ICON_URL"

    cat > "$DESKTOP_FILE" <<DESKTOP
[Desktop Entry]
Name=Hydra Launcher
Comment=The game launcher for the 21st century
Exec=${APPIMAGE_PATH} %U
Icon=hydra
Type=Application
Categories=Game;
StartupWMClass=hydralauncher
Terminal=false
DESKTOP
    ok "Desktop entry created"
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        [ -f "$rc" ] && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc" && break
      done
      warn "Added ~/.local/bin to PATH — restart your shell to apply"
    fi
    ;;
esac

# ─── Done ────────────────────────────────────────────────────────────────────

echo ""
divider
echo ""

echo -e "  ${OK} ${BOLD}${BTEAL}Hydra is ready.${RESET}"
echo -e "  ${DOT} Launch from your app menu, or run: ${BOLD}${TEAL}hydra${RESET}"
echo ""
echo -e "  ${DIM}To uninstall:${RESET}"
if [ "$PKG_MGR" = "appimage" ]; then
  echo -e "  ${DIM}  rm \"$APPIMAGE_PATH\" \"$WRAPPER_PATH\" \"$DESKTOP_FILE\"${RESET}"
elif [ "$PKG_MGR" = "apt" ]; then
  echo -e "  ${DIM}  sudo apt remove hydralauncher${RESET}"
else
  echo -e "  ${DIM}  sudo ${PKG_MGR} remove hydralauncher${RESET}"
fi
echo ""
divider
echo -e "  ${DIM}Docs → docs.hydralauncher.gg  ·  Issues → github.com/hydralauncher/hydra/issues${RESET}"
echo ""

