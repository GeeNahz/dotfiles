#!/bin/bash
# scripts/lib.sh — shared library
# Sourced by every module and by the orchestrator.
# Guard prevents double-loading when multiple modules source this file.

[[ -n "${_LIB_LOADED:-}" ]] && return
_LIB_LOADED=1

# ── Colours & output helpers ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

info() { printf "${BLUE}[info]${NC}  %s\n" "$*"; }
ok()   { printf "${GREEN}[ ok ]${NC}  %s\n" "$*"; }
warn() { printf "${YELLOW}[warn]${NC}  %s\n" "$*"; }
die()  { printf "${RED}[err]${NC}   %s\n" "$*" >&2; exit 1; }
step() { printf "\n${BOLD}══ %s${NC}\n" "$*"; }

# ── Paths ─────────────────────────────────────────────────────────────────────
# Resolves to the dotfiles root regardless of where lib.sh is sourced from.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

# ── OS (set at runtime by detect_os) ─────────────────────────────────────────
export OS=""

# ── Package lists ─────────────────────────────────────────────────────────────

# Arch — official repos (installed via yay which wraps pacman)
ARCH_PKGS=(
  base-devel git stow zsh neovim kitty tmux fzf bat ripgrep
  starship yazi waybar hyprland hyprlock hyprpaper rofi-wayland
  gcc curl wget
  # Erlang/OTP build dependencies
  libssh openssl ncurses unixodbc wxwidgets-gtk3 libxslt
  # Screenshot tools
  grim slurp wl-clipboard
)
# Arch — AUR only
ARCH_AUR_PKGS=(
  emote       # emoji picker
  # grimblast removed — using grim + slurp + wl-clipboard directly instead
)

# macOS — Homebrew formulas
MAC_PKGS=(
  git stow zsh neovim tmux fzf bat ripgrep starship yazi gcc curl wget
  # Erlang/OTP build dependencies
  openssl readline libyaml wxwidgets
)
# macOS — Homebrew casks
MAC_CASKS=(kitty)

export ARCH_PKGS ARCH_AUR_PKGS MAC_PKGS MAC_CASKS

# ── Stow package lists ────────────────────────────────────────────────────────
# Stale/archived dirs (alacritty, i3, picom, polybar, rofi, wofi,
# nvim_v1, nvim.v11, zsh.old) are intentionally excluded.

ARCH_STOW_PKGS=(
  backgrounds fonts hypr hyprland-rofi kitty
  nvim starship tmux vim waybar yazi zsh
)
MAC_STOW_PKGS=(kitty nvim starship tmux vim yazi zsh)

export ARCH_STOW_PKGS MAC_STOW_PKGS

# ── OS detection ──────────────────────────────────────────────────────────────
detect_os() {
  step "Detecting OS"
  if   [[ "$OSTYPE" == "darwin"* ]];  then OS="mac";  info "macOS detected"
  elif [[ -f /etc/arch-release ]];    then OS="arch"; info "Arch Linux detected"
  else die "Unsupported OS — only macOS and Arch Linux are supported"; fi
}
