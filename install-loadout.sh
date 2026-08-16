#!/usr/bin/env bash
# clone-panda-msi — reproduces the standard software loadout on any EndeavourOS box.
# Run this AFTER endeavouros-deploy and BEFORE riced-potatoes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing native packages (pacman)..."
sudo pacman -S --needed --noconfirm - < "$SCRIPT_DIR/pkglist-pacman.txt"

echo "==> Checking for an AUR helper..."
if ! command -v yay &>/dev/null; then
    echo "    yay not found — bootstrapping it now."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay-bootstrap
    (cd /tmp/yay-bootstrap && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bootstrap
fi

echo "==> Installing AUR packages (yay)..."
yay -S --needed --noconfirm - < "$SCRIPT_DIR/pkglist-aur.txt"

echo "==> Installing Flatpak apps..."
if ! command -v flatpak &>/dev/null; then
    sudo pacman -S --needed --noconfirm flatpak
fi
if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
while IFS= read -r app_id; do
    [ -z "$app_id" ] && continue
    flatpak install -y flathub "$app_id"
done < "$SCRIPT_DIR/pkglist-flatpak.txt"

echo "==> Done. Loadout installed."
echo "    Next: run riced-potatoes for the visual theme, then restore personal files."
