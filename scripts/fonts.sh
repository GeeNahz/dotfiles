#!/bin/bash
# scripts/fonts.sh — font setup
# Linux:  fonts/ is stowed to ~/.fonts/ — refreshes the fontconfig cache.
# macOS:  copies TTF files directly to ~/Library/Fonts/ (macOS ignores ~/.fonts).
#
# Run standalone:  bash scripts/fonts.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

setup_fonts() {
  step "Setting up fonts"

  if [[ "${OS:-}" == "arch" ]]; then
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

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  [[ -z "${OS:-}" ]] && detect_os
  setup_fonts
fi
