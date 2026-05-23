# dotfiles

Personal dotfiles for Arch Linux (Hyprland) and macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Quick start

```bash
git clone git@github.com:GeeNahz/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install_dev_setup.sh
```

The script detects your OS, installs packages, sets up tooling, and symlinks configs. It prompts for your password where `sudo` is needed (package installs, `/etc/shells`). The stow step itself is fully user-space.

> **Re-running is safe.** Every step checks whether it's already done before acting.

---

## What's included

| Package      | Arch Linux | macOS | Notes |
|--------------|:---:|:---:|-------|
| `zsh`        | ✓ | ✓ | zinit, autosuggestions, syntax-highlighting |
| `starship`   | ✓ | ✓ | prompt — custom config in `starship/` |
| `nvim`       | ✓ | ✓ | lazy.nvim, LSP, Codeium, Catppuccin |
| `vim`        | ✓ | ✓ | vim-plug, NERDTree, ALE, Catppuccin |
| `tmux`       | ✓ | ✓ | TPM, catppuccin theme (v2.1.3), vim-navigator |
| `kitty`      | ✓ | ✓ | Catppuccin Mocha theme, JetBrains Mono |
| `yazi`       | ✓ | ✓ | file manager, Catppuccin Mocha theme |
| `fonts`      | ✓ | ✓ | JetBrainsMono Nerd Font, MesloLGS NF |
| `backgrounds`| ✓ | ✓ | wallpapers → `~/.config/backgrounds/` |
| `hypr`       | ✓ | — | Hyprland, Hyprlock, Hyprpaper |
| `hyprland-rofi` | ✓ | — | Rofi config for Hyprland |
| `waybar`     | ✓ | — | status bar, Catppuccin Mocha |

### Languages (installed via asdf)

Node.js · Python · Erlang · Elixir

---

## Directory structure

```
dotfiles/
├── install_dev_setup.sh   ← main setup script
│
├── zsh/                   .zshrc, .zsh/ (plugin stubs)
├── starship/              .config/starship/starship.toml
├── nvim/                  .config/nvim/ (lazy.nvim setup)
├── vim/                   .vimrc, .vim/ (vim-plug setup)
├── tmux/                  .tmux.conf
├── kitty/                 .config/kitty/kitty.conf
├── yazi/                  .config/yazi/
├── fonts/                 .fonts/ (TTF files)
├── backgrounds/           .config/backgrounds/ (wallpapers)
├── hypr/                  .config/hypr/ (Hyprland configs)
├── hyprland-rofi/         .config/rofi/ (Rofi for Hyprland)
└── waybar/                .config/waybar/
```

**Archived / not stowed** (kept for reference):

| Directory | Reason archived |
|-----------|-----------------|
| `alacritty/` | Replaced by kitty |
| `i3/`, `picom/`, `polybar/`, `rofi/`, `wofi/` | Replaced by Hyprland stack |
| `nvim_v1/`, `nvim.v11/` | Old nvim configs |
| `zsh.old/` | Old p10k-based zsh config |

---

## What the install script does

1. **Detects OS** — Arch Linux or macOS
2. **Installs packages**
   - Arch: `pacman` + `yay` (AUR) — installs Hyprland, waybar, rofi, kitty, nvim, tmux, fzf, bat, ripgrep, starship, yazi, and Erlang build deps
   - macOS: Homebrew — installs nvim, tmux, fzf, bat, ripgrep, starship, yazi, kitty (cask), and Erlang build deps
3. **Clones Zsh plugins** to `~/.zsh/` (must happen before stow so stub dirs aren't symlinked empty)
4. **Installs Tmux Plugin Manager** + catppuccin theme to `~/.tmux/plugins/`
5. **Installs vim-plug** to `~/.vim/autoload/`
6. **Downloads Kitty Catppuccin Mocha theme** to `~/.config/kitty/current-theme.conf`
7. **Installs asdf** (language version manager) via git
8. **Installs languages via asdf**: Node.js, Python, Erlang, Elixir — sets each as global default
9. **Stows dotfiles** — creates symlinks in `$HOME` for all active packages; backs up any conflicting files as `<file>.bak`
10. **Sets up fonts** — Linux: runs `fc-cache`; macOS: copies TTFs to `~/Library/Fonts/`
11. **Changes default shell** to zsh (registers it in `/etc/shells` if needed)

---

## Post-install

After the script finishes and you restart your terminal:

```
# Install tmux plugins
tmux  →  <prefix> + I

# Neovim plugins (auto-installs on first launch)
nvim

# Authenticate Codeium AI completion
nvim  →  :Codeium Auth

# Arch only: apply Hyprland configs
Log out → log back in  (or: hyprctl reload)
```

---

## Manual stow (individual packages)

Run from `~/dotfiles`:

```bash
stow <package-name>          # symlink to ~/
stow --restow <package>      # re-create symlinks (e.g. after moving files)
stow --delete <package>      # remove symlinks
```

Force-stow when a conflicting file already exists (the install script does this automatically):

```bash
# Back up the conflicting file first, then stow
mv ~/.zshrc ~/.zshrc.bak
stow zsh
```

---

## Stow — no sudo required

Stow symlinks everything into your home directory, so it never needs elevated privileges. The old `sudo stow` pattern in the README (and the zshrc alias) is only relevant if stowing into system paths like `/usr/local/stow` — which we don't do here.

---

## Notes

- **Navigation keybindings** are remapped to vim motions (`h j k l`) in nvim, tmux, and Hyprland.
- **Hyprpaper** is configured to use `~/.config/backgrounds/archtv.png`. Edit `hypr/.config/hypr/hyprpaper.conf` to change the wallpaper.
- **Codeium** requires a free account and one-time auth (`:Codeium Auth` in nvim).
- **Erlang** compiles from source via asdf — expect 10–20 minutes on first install.
- The **zinit** plugin manager is bootstrapped automatically on first zsh launch (already wired in `.zshrc`).
