#!/bin/bash
# scripts/kitty.sh — Kitty terminal theme setup
# Downloads the Catppuccin Mocha theme to ~/.config/kitty/current-theme.conf.
# kitty.conf references this file via `include current-theme.conf`; stow only
# links kitty.conf itself so the theme file must be placed separately.
#
# Run standalone:  bash scripts/kitty.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

setup_kitty_theme() {
  step "Setting up Kitty theme"
  local theme_file="$HOME/.config/kitty/current-theme.conf"
  mkdir -p "$HOME/.config/kitty"

  if [[ ! -f "$theme_file" ]]; then
    info "Downloading Catppuccin Mocha theme for kitty..."
    curl -fsSL \
      "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf" \
      -o "$theme_file"
    ok "Kitty theme saved"
  else
    info "Kitty theme — already present, skipping"
  fi
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_kitty_theme
fi
