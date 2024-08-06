## Setup rofi for hyprland

Install rofi for wayland
```sh
pacman -S rofi-wayland
```
Symlink the rofi config from the dotfiles
```sh
sudo stow hyprland-rofi
```

> !NOTE: Just in case there is already a config.rasi file, a conflict will arise. If that happens, you can override the file with the one from dotfiles using the `--adopt` flag. Ensure to backup every file before using this flag.
