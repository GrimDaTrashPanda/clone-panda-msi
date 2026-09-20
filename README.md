# clone-panda-msi

The standard app loadout for any Linux distro. The lists in this repo are the single source of truth for which apps get installed, and one script installs them on any distro that can run Flatpak.

Despite the name, this isn't tied to the MSI. "msi" marks the machine the first snapshot was captured from, not a requirement.

## How it's used

The distro deploy repos call `install-loadout.sh` as their last step, so you normally never run it by hand:

- [endeavouros-deploy](https://github.com/GrimDaTrashPanda/endeavouros-deploy)
- [linux-mint-deploy](https://github.com/GrimDaTrashPanda/linux-mint-deploy)
- [debian-deploy](https://github.com/GrimDaTrashPanda/debian-deploy)
- [almalinux-workstation-deploy](https://github.com/GrimDaTrashPanda/almalinux-workstation-deploy)

To run it on its own:

    git clone https://github.com/GrimDaTrashPanda/clone-panda-msi.git
    cd clone-panda-msi
    bash install-loadout.sh

## What's in here

- `pkglist-flatpak.txt`: Flathub apps, installed on every distro
- `pkglist-pacman.txt`: native packages, Arch only
- `pkglist-native-as-flatpak.txt`: on non-Arch distros, the apps that are native on Arch, installed as Flatpaks instead
- `install-loadout.sh`: installs the lists above, skips anything already present, keeps going if one item fails, and prints a summary at the end

## Changing the loadout

- **Add or remove a Flathub app:** edit `pkglist-flatpak.txt`, one app ID per line (`flatpak search <name>` shows the ID).
- **Add a native Arch app:** add it to `pkglist-pacman.txt`, and add its Flathub ID to `pkglist-native-as-flatpak.txt` so other distros get it too.
- **Don't overwrite `pkglist-pacman.txt` with a `pacman -Qqe` dump.** The list is deliberately small. A full dump pulls in desktop and hardware packages that don't belong on other machines.

## Not included

- Theming and desktop settings: [riced-potatoes](https://github.com/GrimDaTrashPanda/riced-potatoes)
- Base OS setup: the deploy repos above
- Personal files and configs
- Screen recorder: still TBD
