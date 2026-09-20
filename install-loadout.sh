#!/usr/bin/env bash
# clone-panda-msi: standard app loadout on any distro.
# Arch: native list (pkglist-pacman.txt) + Flatpaks.
# Anything else: Flatpaks only, with the Arch-native apps installed as
# Flatpaks too (pkglist-native-as-flatpak.txt).
# Skips anything already installed; keeps going on failures and summarizes.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=()

read_list() { grep -vE '^\s*(#|$)' "$1"; }

install_flatpak_app() {
  local app="$1"
  if flatpak info "$app" &>/dev/null; then
    echo "  [skip] $app already installed"
    return
  fi
  echo "  [install] $app"
  flatpak install -y flathub "$app" </dev/null || FAILED+=("$app")
}

echo "== Ensuring Flatpak + Flathub are available =="
if ! command -v flatpak &>/dev/null; then
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm flatpak
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y flatpak
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y flatpak
  else
    echo "Can't install flatpak on this distro. Install it and re-run."
    exit 1
  fi
fi
if ! flatpak remote-list | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

if command -v pacman &>/dev/null; then
  echo "== Installing native (pacman) packages =="
  while read -r pkg; do
    if pacman -Qq "$pkg" &>/dev/null; then
      echo "  [skip] $pkg already installed"
    else
      echo "  [install] $pkg"
      sudo pacman -S --needed --noconfirm "$pkg" </dev/null || FAILED+=("$pkg")
    fi
  done < <(read_list "$SCRIPT_DIR/pkglist-pacman.txt")
else
  echo "== Non-Arch distro: installing Arch-native apps as Flatpaks =="
  while read -r app; do
    install_flatpak_app "$app"
  done < <(read_list "$SCRIPT_DIR/pkglist-native-as-flatpak.txt")
fi

echo "== Installing Flatpak packages =="
while read -r app; do
  install_flatpak_app "$app"
done < <(read_list "$SCRIPT_DIR/pkglist-flatpak.txt")

echo ""
if [ ${#FAILED[@]} -gt 0 ]; then
  echo "== Done, but these failed =="
  printf '  %s\n' "${FAILED[@]}"
else
  echo "== Done. Loadout installed. =="
fi
echo "Note: screen recorder is still TBD — not included in this pass."
