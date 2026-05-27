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
| `kitty`      | ✓ | ✓ | Catppuccin Mocha theme, JetBrainsMono Nerd Font Mono |
| `yazi`       | ✓ | ✓ | file manager, Catppuccin Mocha theme |
| `fonts`      | ✓ | ✓ | JetBrainsMono Nerd Font Mono, MesloLGS NF |
| `backgrounds`| ✓ | ✓ | wallpapers → `~/.config/backgrounds/` |
| `hypr`       | ✓ | — | Hyprland, Hyprlock, Hyprpaper, screenshots |
| `hyprland-rofi` | ✓ | — | Rofi config for Hyprland |
| `waybar`     | ✓ | — | status bar, Catppuccin Mocha |

### Languages (installed via asdf)

Node.js · Python · Erlang · Elixir

---

## Directory structure

```
dotfiles/
├── install_dev_setup.sh   ← orchestrator — sources all modules and runs them in order
├── scripts/               ← modular setup scripts (each independently executable)
│   ├── lib.sh             ← shared: colours, helpers, constants, detect_os()
│   ├── packages.sh        ← package managers (Arch/yay + macOS/brew)
│   ├── zsh.sh             ← zsh plugin cloning
│   ├── tmux.sh            ← TPM + catppuccin theme
│   ├── vim.sh             ← vim-plug
│   ├── kitty.sh           ← kitty Catppuccin theme download
│   ├── asdf.sh            ← asdf install + Node, Python, Erlang, Elixir
│   ├── stow.sh            ← dotfile symlinking
│   ├── fonts.sh           ← font cache (Linux) / font copy (macOS)
│   └── shell.sh           ← default shell change
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

## Running individual modules

Every script in `scripts/` is independently executable — useful when you only need to re-run one step:

```bash
bash scripts/tmux.sh       # re-install TPM + catppuccin
bash scripts/stow.sh       # re-symlink dotfiles
bash scripts/asdf.sh       # re-run language installs
bash scripts/packages.sh   # install/check packages only
# etc.
```

Each module sources `scripts/lib.sh` for shared helpers and constants, then checks `OS` if it needs platform-specific behaviour — detecting it automatically when run standalone.

---

## What the install script does

1. **Detects OS** — Arch Linux or macOS
2. **Installs packages**
   - Arch: `pacman` + `yay` (AUR) — installs Hyprland, waybar, rofi, kitty, nvim, tmux, fzf, bat, ripgrep, starship, yazi, grim, slurp, wl-clipboard, and Erlang build deps
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

## Hyprland keybindings reference

| Combo | Action |
|-------|--------|
| `SUPER + RETURN` | Open terminal (kitty) |
| `SUPER + SPACE` | App launcher (rofi) |
| `SUPER + Q` | Close active window |
| `SUPER + E` | File manager (dolphin) |
| `SUPER + V` | Toggle floating |
| `SUPER + H/J/K/L` | Move focus (vim motions) |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + R` → `H/J/K/L` | Resize window (submap) |
| `SUPER + 1–0` | Switch workspace |
| `SUPER + SHIFT + 1–0` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + ALT + L` | Lock screen (hyprlock) |
| `SUPER + ALT + S` | Screenshot — full screen → save to file + clipboard |
| `SUPER + ALT + SHIFT + S` | Screenshot — select region → clipboard |
| `SUPER + ALT + CTRL + S` | Screenshot — select region → save to `~/Pictures/Screenshots/` |
| `CTRL + ALT + E` | Emoji picker (emote) |

Screenshots are saved as timestamped PNGs (`YYYYMMDD_HHMMSS.png`) in `~/Pictures/Screenshots/`.

---

## Notes

- **Navigation keybindings** are remapped to vim motions (`h j k l`) in nvim, tmux, and Hyprland.
- **Hyprpaper** is configured to use `~/.config/backgrounds/archtv.png`. Edit `hypr/.config/hypr/hyprpaper.conf` to change the wallpaper.
- **Kitty font** must be `JetBrainsMono Nerd Font Mono` (not MesloLGS NF) for Nerd Font glyphs in the tmux status bar to render correctly. Running `kitten choose-fonts` will overwrite this — set it back in `kitty/.config/kitty/kitty.conf` if needed.
- **tmux glyphs** rendering as `_` inside kitty is fixed by `term xterm-256color` in `kitty.conf` and `terminal-overrides ",xterm*:RGB"` in `.tmux.conf` — both are already set.
- **Codeium** requires a free account and one-time auth (`:Codeium Auth` in nvim).
- **Erlang** compiles from source via asdf — expect 10–20 minutes on first install.
- The **zinit** plugin manager is bootstrapped automatically on first zsh launch (already wired in `.zshrc`).
