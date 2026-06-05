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
| `tmux`       | ✓ | ✓ | TPM, catppuccin theme, vim-tmux-navigator |
| `kitty`      | ✓ | ✓ | Catppuccin Mocha theme, MesloLGS NF font |
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
4. **Installs Tmux Plugin Manager (TPM)** + catppuccin theme to `~/.tmux/plugins/`
5. **Installs vim-plug** to `~/.vim/autoload/`
6. **Downloads Kitty Catppuccin Mocha theme** to `~/.config/kitty/current-theme.conf`
7. **Installs asdf** (language version manager) via git
8. **Installs languages via asdf**: Node.js, Python, Erlang, Elixir — sets each as global default
9. **Stows dotfiles** — creates symlinks in `$HOME` for all active packages; backs up any conflicting files as `<file>.bak`
10. **Sets up fonts** — Linux: runs `fc-cache`; macOS: copies TTFs to `~/Library/Fonts/`
11. **Changes default shell** to zsh (registers it in `/etc/shells` if needed)

---

## Post-install setup

The install script handles bootstrapping, but a few tools require one-time manual steps after it completes.

### 1. tmux plugins

The install script sets up TPM (Tmux Plugin Manager) but does **not** install the declared plugins — that requires a running tmux session.

```
tmux                     # start a tmux session
```

Then press **`C-s I`** (`prefix + Shift-I`) to fetch and install all plugins:

- `catppuccin/tmux` — status bar theme
- `christoomey/vim-tmux-navigator` — seamless pane navigation with nvim

> **Important:** Until `vim-tmux-navigator` is installed, `Ctrl-h/j/k/l` will not navigate *from* a tmux pane *into* nvim. Navigation in the other direction (nvim → tmux) works immediately via the nvim plugin, but the tmux side requires the plugin to be present.

To reload the config at any time without restarting:

```
prefix + r       (i.e. C-s r)
```

### 2. Neovim plugins

Launch nvim — `lazy.nvim` auto-installs all plugins on first run:

```
nvim
```

Wait for the install to complete before using the editor. Subsequent launches are instant.

### 3. Codeium (AI completion)

Inside nvim, authenticate with your free Codeium account:

```
:Codeium Auth
```

Follow the browser prompt to link your account. Only needed once per machine.

### 4. Hyprland (Arch only)

Log out and back in to apply the Hyprland config, or reload without logging out:

```
hyprctl reload
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

## Keybindings reference

All three tools — Hyprland, tmux, and Neovim — share the same vim-motion convention (`h j k l`) for navigation.

---

### Hyprland (Arch Linux only)

| Combo | Action |
|-------|--------|
| `SUPER + RETURN` | Open terminal (kitty) |
| `SUPER + SPACE` | App launcher (rofi) |
| `SUPER + Q` | Close active window |
| `SUPER + E` | File manager (dolphin) |
| `SUPER + V` | Toggle floating |
| `SUPER + M` | Exit Hyprland |
| `SUPER + H/J/K/L` | Move focus (vim motions) |
| `SUPER + ←/↑/↓/→` | Move focus (arrow keys) |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + R` → `H/J/K/L` | Resize window (submap — press `Esc` to exit) |
| `SUPER + 1–0` | Switch workspace |
| `SUPER + SHIFT + 1–0` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + SHIFT + S` | Move window to scratchpad |
| `SUPER + ALT + L` | Lock screen (hyprlock) |
| `SUPER + ALT + S` | Screenshot — full screen → save + clipboard |
| `SUPER + ALT + SHIFT + S` | Screenshot — select region → clipboard |
| `SUPER + ALT + CTRL + S` | Screenshot — select region → save to `~/Pictures/Screenshots/` |
| `CTRL + ALT + E` | Emoji picker (emote) |
| `SUPER + scroll` | Scroll through workspaces |
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |

Screenshots are saved as timestamped PNGs (`YYYYMMDD_HHMMSS.png`) in `~/Pictures/Screenshots/`.

---

### tmux

Prefix key: **`C-s`** (i.e. `Ctrl + s`)

#### Session & config

| Combo | Action |
|-------|--------|
| `prefix + r` | Reload tmux config |
| `prefix + I` | Install plugins via TPM (run once after first launch) |

#### Pane navigation

| Combo | Action |
|-------|--------|
| `prefix + h` | Focus pane left |
| `prefix + j` | Focus pane down |
| `prefix + k` | Focus pane up |
| `prefix + l` | Focus pane right |
| `Ctrl + h/j/k/l` | Focus pane or nvim split — seamless (requires `vim-tmux-navigator` plugin) |

> `Ctrl + h/j/k/l` works across both tmux panes and nvim splits without switching modes. It requires the `vim-tmux-navigator` TPM plugin to be installed (`prefix + I`). Without it, use `prefix + h/j/k/l` to navigate tmux panes.

#### Copy mode (vi keys)

| Combo | Action |
|-------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Begin selection (vi mode) |
| `y` | Copy selection |
| `q` | Exit copy mode |

---

### Neovim

Leader key: **`<Space>`**

> `Ctrl + h/j/k/l` navigate seamlessly across nvim splits **and** tmux panes via `nvim-tmux-navigator`. The tmux side of this requires the `vim-tmux-navigator` plugin installed in tmux (`prefix + I`).

#### Window & pane navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | Normal | Navigate left (nvim split or tmux pane) |
| `<C-j>` | Normal | Navigate down (nvim split or tmux pane) |
| `<C-k>` | Normal | Navigate up (nvim split or tmux pane) |
| `<C-l>` | Normal | Navigate right (nvim split or tmux pane) |
| `<C-n>` | Normal | Toggle file tree (NvimTree) |

#### Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<leader>n` | Normal | Next buffer |
| `<leader>p` | Normal | Previous buffer |
| `<leader>x` | Normal | Close current buffer |
| `<leader>X` | Normal | Close all buffers |

#### Search & files (Telescope)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fp` | Normal | Git files |
| `<leader>fg` | Normal | Live grep |
| `<leader>fb` | Normal | Open buffers |

#### LSP

| Key | Mode | Action |
|-----|------|--------|
| `K` | Normal | Hover docs |
| `<leader>gd` | Normal | Go to definition |
| `<leader>gr` | Normal | Go to references |
| `<leader>ca` | Normal | Code action |
| `<leader>gf` | Normal | Format buffer |

> `lsp-zero` also registers its default LSP keymaps per buffer on attach. See `:help lsp-zero-keybindings` inside nvim for the full list.

#### Completion (insert mode)

| Key | Mode | Action |
|-----|------|--------|
| `<C-y>` | Insert | Confirm completion |
| `<C-Space>` | Insert | Trigger completion |
| `<C-u>` | Insert | Scroll docs up |
| `<C-d>` | Insert | Scroll docs down |
| `<C-f>` | Insert | LuaSnip jump forward |
| `<C-b>` | Insert | LuaSnip jump backward |

#### Diagnostics (Trouble)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | Normal | Toggle all diagnostics |
| `<leader>tT` | Normal | Toggle buffer diagnostics |
| `<leader>cs` | Normal | Toggle symbols panel |
| `<leader>cl` | Normal | Toggle LSP panel (defs / refs) |
| `<leader>xL` | Normal | Toggle location list |
| `<leader>xQ` | Normal | Toggle quickfix list |

#### Editing & utilities

| Key | Mode | Action |
|-----|------|--------|
| `<leader>y` | Normal / Visual | Yank to system clipboard |
| `<leader>/` | Normal / Visual | Toggle comment |
| `<leader>h` | Normal | Clear search highlight |
| `<leader>mp` | Normal | Toggle Markdown preview |

> Formatting on save is automatic via `conform.nvim` for Lua, Python, Rust, and JS/TS files.

---

## Notes

- **Navigation** uses vim motions (`h j k l`) consistently across nvim, tmux, and Hyprland.
- **tmux `C-h/j/k/l`** requires the `vim-tmux-navigator` plugin installed via `prefix + I`. Without it, use `prefix + h/j/k/l` for pane navigation.
- **Hyprpaper** is configured to use `~/.config/backgrounds/archtv.png`. Edit `hypr/.config/hypr/hyprpaper.conf` to change the wallpaper.
- **Kitty font** is set to `MesloLGS NF`. Running `kitten choose-fonts` may overwrite this — restore it in `kitty/.config/kitty/kitty.conf` if needed.
- **tmux glyphs** rendering as `_` is caused by tmux failing to detect UTF-8. Fixed system-wide by setting `LANG=en_NG.UTF-8` in `/etc/locale.conf`. The `term xterm-256color` setting in `kitty.conf` and `terminal-overrides ",xterm*:RGB"` in `.tmux.conf` handle truecolor and Nerd Font rendering.
- **Codeium** requires a free account and one-time auth (`:Codeium Auth` in nvim).
- **Erlang** compiles from source via asdf — expect 10–20 minutes on first install.
- The **zinit** plugin manager is bootstrapped automatically on first zsh launch (already wired in `.zshrc`).
