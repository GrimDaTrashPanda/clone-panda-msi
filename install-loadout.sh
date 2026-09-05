#!/usr/bin/env bash
# clone-panda-msi — trimmed loadout installer
# No AUR. Native-first, Flatpak fallback. Skips anything already present.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "== Ensuring Flatpak + Flathub are available =="
if ! command -v flatpak &>/dev/null; then
    sudo pacman -S --needed --noconfirm flatpak
fi
if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "== Installing native (pacman) packages =="
while read -r pkg; do
    [ -z "$pkg" ] && continue
    if pacman -Qq "$pkg" &>/dev/null; then
        echo "  [skip] $pkg already installed"
    else
        echo "  [install] $pkg"
        sudo pacman -S --needed --noconfirm "$pkg"
    fi
done < "$SCRIPT_DIR/pkglist-pacman.txt"

echo "== Installing Flatpak packages =="
while read -r app; do
    [ -z "$app" ] && continue
    if flatpak list --app --columns=application | grep -qx "$app"; then
        echo "  [skip] $app already installed"
    else
        echo "  [install] $app"
        flatpak install -y flathub "$app"
    fi
done < "$SCRIPT_DIR/pkglist-flatpak.txt"

echo "== Done. Loadout installed. =="
echo "Note: screen recorder is still TBD — not included in this pass."
