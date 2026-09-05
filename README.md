# clone-panda-msi

Reproduces my standard software loadout on any EndeavourOS install.

Despite the name, this is **not hardware-locked to the MSI** — "msi" marks where this
snapshot was originally captured (Warranty-is-Void), not a requirement. Run this on any
machine with a fresh EndeavourOS install and you'll end up with the same terminal,
apps, and tools, minus personal files (those live on external storage and get
restored separately).

No AUR. Native-first, Flatpak fallback for everything else.

## What this does NOT do

- No dconf/theme/wallpaper setup — that's [riced-potatoes](https://github.com/GrimDaTrashPanda/riced-potatoes)
- No base OS install/hardening — that's [endeavouros-deploy](https://github.com/GrimDaTrashPanda/endeavouros-deploy)
- No personal files, documents, or configs — those live on external storage

## Rebuild order

1. Fresh EndeavourOS install
2. Run `endeavouros-deploy` (base OS setup)
3. Run this repo (`install-loadout.sh`) — gets you a working baseline terminal/toolset
4. Run `riced-potatoes` (visual theme/rice)
5. Restore personal files from external storage — trivial once the above is done

## Usage

```
git clone https://github.com/GrimDaTrashPanda/clone-panda-msi.git
cd clone-panda-msi
chmod +x install-loadout.sh
./install-loadout.sh
```

## What's in here

- `pkglist-pacman.txt` — native packages, installed via `pacman -S --needed`
- `pkglist-flatpak.txt` — Flatpak apps, installed from Flathub
- `install-loadout.sh` — installs both lists in order, skipping anything already present,
  and bootstraps Flatpak/Flathub itself if missing

## Current loadout

- Firefox (stock, untouched — default browser)
- Brave (second browser)
- LibreOffice
- Kdenlive, OBS Studio, GIMP

**Pending:** screen recording utility (not yet chosen, low priority)

## Keeping this current

Whenever you add new software you want to persist across rebuilds, regenerate the lists
on the source machine and push:

```
pacman -Qqe > pkglist-pacman.txt
flatpak list --app --columns=application > pkglist-flatpak.txt
git add -A && git commit -m "refresh package snapshot"
git push
```
