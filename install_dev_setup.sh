#!/bin/bash
# Dotfiles install script — Arch Linux & macOS
# Usage: bash install_dev_setup.sh
# Requires sudo only for: pacman/yay installs, adding zsh to /etc/shells

set -euo pipefail

# ── Colours & helpers ─────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info() { printf "${BLUE}[info]${NC}  %s\n" "$*"; }
ok()   { printf "${GREEN}[ ok ]${NC}  %s\n" "$*"; }
warn() { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
die()  { printf "${RED}[err]${NC}   %s\n" "$*" >&2; exit 1; }
step() { printf "\n${BOLD}══ %s${NC}\n" "$*"; }

# ── Constants ─────────────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=""

# Arch packages (official repos — installed via yay which wraps pacman)
ARCH_PKGS=(
  base-devel git stow zsh neovim kitty tmux fzf bat ripgrep
  starship yazi waybar hyprland hyprlock hyprpaper rofi-wayland
  gcc curl wget
  # Erlang/OTP build dependencies
  libssh openssl ncurses unixodbc wxwidgets-gtk3 libxslt
)
# AUR-only packages
ARCH_AUR_PKGS=(emote)

# macOS packages (Homebrew)
MAC_PKGS=(
  git stow zsh neovim tmux fzf bat ripgrep starship yazi gcc curl wget
  # Erlang/OTP build dependencies
  openssl readline libyaml wxwidgets
)
MAC_CASKS=(kitty)

# Stow packages per OS (stale/archived dirs are intentionally excluded)
ARCH_STOW_PKGS=(backgrounds fonts hypr hyprland-rofi kitty nvim starship tmux vim waybar yazi zsh)
MAC_STOW_PKGS=(kitty nvim starship tmux vim yazi zsh)

# ── OS detection ──────────────────────────────────────────────────────────────
detect_os() {
  step "Detecting OS"
  if   [[ "$OSTYPE" == "darwin"* ]];  then OS="mac";  info "macOS detected"
  elif [[ -f /etc/arch-release ]];    then OS="arch"; info "Arch Linux detected"
  else die "Unsupported OS — only macOS and Arch Linux are supported"; fi
}

# ── Arch Linux ────────────────────────────────────────────────────────────────
_install_yay() {
  command -v yay &>/dev/null && { info "yay already installed"; return; }
  info "Building yay from AUR..."
  local tmp
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  ok "yay installed"
}

install_packages_arch() {
  step "Installing packages (Arch Linux)"
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm base-devel git
  _install_yay
  yay -S --needed --noconfirm "${ARCH_PKGS[@]}"
  yay -S --needed --noconfirm "${ARCH_AUR_PKGS[@]}"
  ok "Packages installed"
}

# ── macOS ─────────────────────────────────────────────────────────────────────
_install_homebrew() {
  command -v brew &>/dev/null && { info "Homebrew already installed"; return; }
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  local brew_bin
  if   [[ -x /opt/homebrew/bin/brew ]]; then brew_bin=/opt/homebrew/bin/brew   # Apple Silicon
  elif [[ -x /usr/local/bin/brew ]];    then brew_bin=/usr/local/bin/brew       # Intel
  else die "brew not found after install"; fi
  eval "$("$brew_bin" shellenv)"
  ok "Homebrew installed"
}

install_packages_mac() {
  step "Installing packages (macOS)"
  _install_homebrew
  brew install "${MAC_PKGS[@]}"
  brew install --cask "${MAC_CASKS[@]}"
  ok "Packages installed"
}

# ── Zsh plugins ───────────────────────────────────────────────────────────────
# NOTE: Must run BEFORE stow_dotfiles. The repo contains empty stub dirs for
# the plugins so stow doesn't create broken symlinks to nothing. Cloning here
# populates real dirs first; stow then leaves them untouched.
setup_zsh_plugins() {
  step "Setting up Zsh plugins"
  mkdir -p "$HOME/.zsh"

  # Parallel arrays (bash 3.2 compat — no declare -A)
  local plugin_names=(zsh-autosuggestions zsh-syntax-highlighting)
  local plugin_urls=(
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
  )

  local i
  for (( i=0; i<${#plugin_names[@]}; i++ )); do
    local name="${plugin_names[$i]}"
    local url="${plugin_urls[$i]}"
    local target="$HOME/.zsh/$name"
    if [[ -d "$target" && -n "$(ls -A "$target" 2>/dev/null)" ]]; then
      info "$name already present"
    else
      [[ -d "$target" ]] && rm -rf "$target"   # remove empty stub from a prior stow run
      info "Cloning $name..."
      git clone "$url" "$target"
      ok "$name"
    fi
  done
}

# ── Tmux ──────────────────────────────────────────────────────────────────────
setup_tmux() {
  step "Setting up Tmux"

  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed"
  else
    info "TPM already present"
  fi

  if [[ ! -d "$HOME/.tmux/plugins/catppuccin/tmux" ]]; then
    info "Installing catppuccin tmux theme (v2.1.3)..."
    mkdir -p "$HOME/.tmux/plugins/catppuccin"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git \
      "$HOME/.tmux/plugins/catppuccin/tmux"
    ok "catppuccin tmux"
  else
    info "catppuccin tmux already present"
  fi
}

# ── Vim ───────────────────────────────────────────────────────────────────────
setup_vim() {
  step "Setting up Vim"
  local plug="$HOME/.vim/autoload/plug.vim"
  if [[ ! -f "$plug" ]]; then
    info "Installing vim-plug..."
    curl -fLo "$plug" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "vim-plug installed"
  else
    info "vim-plug already present"
  fi
}

# ── Kitty theme ───────────────────────────────────────────────────────────────
setup_kitty_theme() {
  step "Setting up Kitty theme"
  # kitty.conf references `include current-theme.conf`; stow only links kitty.conf
  local theme_file="$HOME/.config/kitty/current-theme.conf"
  mkdir -p "$HOME/.config/kitty"
  if [[ ! -f "$theme_file" ]]; then
    info "Downloading Catppuccin Mocha theme for kitty..."
    curl -fsSL \
      "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf" \
      -o "$theme_file"
    ok "Kitty theme saved"
  else
    info "Kitty theme already present"
  fi
}

# ── asdf ──────────────────────────────────────────────────────────────────────
install_asdf() {
  step "Installing asdf"
  if [[ -d "$HOME/.asdf/.git" ]]; then
    info "asdf already installed, pulling latest..."
    git -C "$HOME/.asdf" pull --ff-only
  else
    info "Cloning asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf"
    ok "asdf installed"
  fi
}

_load_asdf() {
  if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    # shellcheck disable=SC1091
    . "$HOME/.asdf/asdf.sh"
  else
    export PATH="$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"
  fi
}

_plugin_add() {
  local plugin=$1
  asdf plugin list 2>/dev/null | grep -q "^${plugin}$" \
    || { info "Adding plugin: $plugin"; asdf plugin add "$plugin"; }
}

_install_lang() {
  local plugin=$1
  local version
  version=$(asdf latest "$plugin")
  if asdf list "$plugin" 2>/dev/null | grep -qF "$version"; then
    info "$plugin $version already installed"
  else
    info "Installing $plugin $version (this may take a while)..."
    asdf install "$plugin" "$version"
  fi
  asdf global "$plugin" "$version"
  ok "$plugin $version → global"
}

install_languages() {
  step "Installing languages via asdf"
  _load_asdf

  _plugin_add nodejs
  _install_lang nodejs

  _plugin_add python
  _install_lang python

  # Erlang: build deps are already installed in the packages step
  info "Installing Erlang — compilation takes 10–20 min on first run..."
  _plugin_add erlang
  if [[ "$OS" == "mac" ]]; then
    # Point asdf-erlang to homebrew's openssl
    export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
  fi
  _install_lang erlang

  _plugin_add elixir
  _install_lang elixir

  ok "All languages installed"
}

# ── Stow dotfiles ─────────────────────────────────────────────────────────────
_safe_stow() {
  local pkg=$1
  info "Stowing $pkg..."

  local sim_out
  if sim_out=$(stow --target="$HOME" --dir="$DOTFILES_DIR" --simulate "$pkg" 2>&1); then
    stow --target="$HOME" --dir="$DOTFILES_DIR" "$pkg"
    ok "$pkg"
  else
    warn "Conflicts in $pkg — backing up existing files and retrying..."
    # stow prints: "existing target is neither a link nor empty: <relative-path>"
    while IFS= read -r line; do
      local rel_path
      rel_path=$(printf '%s' "$line" | sed 's/.*: //' || true)
      [[ -z "$rel_path" ]] && continue
      local full_path="$HOME/$rel_path"
      if [[ -e "$full_path" && ! -L "$full_path" ]]; then
        mv "$full_path" "${full_path}.bak"
        info "  backed up: ~/$rel_path → ~/${rel_path}.bak"
      fi
    done < <(printf '%s\n' "$sim_out" | grep "existing target")

    stow --target="$HOME" --dir="$DOTFILES_DIR" "$pkg" \
      && ok "$pkg (conflicts backed up)" \
      || warn "Could not fully stow $pkg — check manually"
  fi
}

stow_dotfiles() {
  step "Symlinking dotfiles via stow"
  local -a pkgs
  if [[ "$OS" == "arch" ]]; then
    pkgs=("${ARCH_STOW_PKGS[@]}")
  else
    pkgs=("${MAC_STOW_PKGS[@]}")
  fi
  for pkg in "${pkgs[@]}"; do
    _safe_stow "$pkg"
  done
}

# ── Fonts ─────────────────────────────────────────────────────────────────────
setup_fonts() {
  step "Setting up fonts"
  if [[ "$OS" == "arch" ]]; then
    # fonts/ was stowed to ~/.fonts/ — refresh the fontconfig cache
    fc-cache -fv
    ok "Font cache refreshed"
  else
    # macOS uses ~/Library/Fonts — copy TTFs directly (stow not used here)
    info "Copying fonts to ~/Library/Fonts..."
    mkdir -p "$HOME/Library/Fonts"
    cp -r "$DOTFILES_DIR/fonts/.fonts/"* "$HOME/Library/Fonts/"
    ok "Fonts copied"
  fi
}

# ── Default shell ─────────────────────────────────────────────────────────────
change_default_shell() {
  step "Setting Zsh as default shell"
  local zsh_path
  zsh_path=$(command -v zsh 2>/dev/null) || { warn "zsh not in PATH — skipping"; return; }

  if [[ "${SHELL:-}" == *zsh* ]]; then
    info "Already using zsh"
    return
  fi

  if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    info "Registering $zsh_path in /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  chsh -s "$zsh_path"
  ok "Default shell → $zsh_path"
}

# ── Finish ────────────────────────────────────────────────────────────────────
print_done() {
  printf "\n${BOLD}${GREEN}╔══════════════════════════════════════════════╗${NC}\n"
  printf "${BOLD}${GREEN}║  Done! Restart your terminal to apply all    ║${NC}\n"
  printf "${BOLD}${GREEN}║  changes.                                    ║${NC}\n"
  printf "${BOLD}${GREEN}╚══════════════════════════════════════════════╝${NC}\n\n"
  printf "  Next steps:\n"
  printf "  1. Restart terminal  (or: exec zsh)\n"
  printf "  2. Open tmux → press <prefix> + I  to install tmux plugins\n"
  printf "  3. Open nvim → lazy.nvim auto-installs plugins on first launch\n"
  printf "  4. In nvim → :Codeium Auth  to authenticate AI completion\n"
  if [[ "$OS" == "arch" ]]; then
  printf "  5. Log out and back in to apply Hyprland / Waybar configs\n"
  fi
  printf "\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  printf "\n${BOLD}  Dotfiles install — Arch Linux & macOS${NC}\n"
  printf "  Dotfiles dir: %s\n\n" "$DOTFILES_DIR"

  detect_os

  case "$OS" in
    arch) install_packages_arch ;;
    mac)  install_packages_mac  ;;
  esac

  setup_zsh_plugins   # must precede stow_dotfiles (populates plugin dirs before stow runs)
  setup_tmux
  setup_vim
  setup_kitty_theme
  install_asdf
  install_languages
  stow_dotfiles
  setup_fonts
  change_default_shell
  print_done
}

main
