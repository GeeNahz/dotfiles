#!/bin/bash
# scripts/packages.sh — package installation
# Arch Linux: pacman + yay (AUR)
# macOS:      Homebrew formulas + casks
#
# Run standalone:  bash scripts/packages.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

# ── Arch helpers ──────────────────────────────────────────────────────────────
_is_pkg_installed_arch() {
  # Returns 0 (true) if the package is already in the local pacman DB
  pacman -Qi "$1" &>/dev/null
}

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

  # Check each package — collect only those that are missing
  local to_install=()
  for pkg in "${ARCH_PKGS[@]}" "${ARCH_AUR_PKGS[@]}"; do
    if _is_pkg_installed_arch "$pkg"; then
      info "  $pkg — already installed, skipping"
    else
      info "  $pkg — not found, queued for install"
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -eq 0 ]]; then
    ok "All packages already installed"
  else
    info "Installing ${#to_install[@]} missing package(s)..."
    yay -S --needed --noconfirm "${to_install[@]}"
    ok "Packages installed"
  fi
}

# ── macOS helpers ─────────────────────────────────────────────────────────────
_is_pkg_installed_mac() {
  brew list "$1" &>/dev/null 2>&1
}

_is_cask_installed_mac() {
  brew list --cask "$1" &>/dev/null 2>&1
}

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

  # Formulas
  local to_install=()
  for pkg in "${MAC_PKGS[@]}"; do
    if _is_pkg_installed_mac "$pkg"; then
      info "  $pkg — already installed, skipping"
    else
      info "  $pkg — not found, queued for install"
      to_install+=("$pkg")
    fi
  done

  if [[ ${#to_install[@]} -eq 0 ]]; then
    ok "All formulas already installed"
  else
    info "Installing ${#to_install[@]} missing formula(s)..."
    brew install "${to_install[@]}"
    ok "Formulas installed"
  fi

  # Casks
  local to_install_cask=()
  for cask in "${MAC_CASKS[@]}"; do
    if _is_cask_installed_mac "$cask"; then
      info "  $cask — already installed, skipping"
    else
      info "  $cask — not found, queued for install"
      to_install_cask+=("$cask")
    fi
  done

  if [[ ${#to_install_cask[@]} -eq 0 ]]; then
    ok "All casks already installed"
  else
    info "Installing ${#to_install_cask[@]} missing cask(s)..."
    brew install --cask "${to_install_cask[@]}"
    ok "Casks installed"
  fi
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  [[ -z "${OS:-}" ]] && detect_os
  case "$OS" in
    arch) install_packages_arch ;;
    mac)  install_packages_mac  ;;
  esac
fi
