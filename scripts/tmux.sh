#!/bin/bash
# scripts/tmux.sh — Tmux plugin setup
# Installs TPM (Tmux Plugin Manager) and the catppuccin theme (v2.1.3).
#
# Run standalone:  bash scripts/tmux.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

setup_tmux() {
  step "Setting up Tmux"

  if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed"
  else
    info "TPM — already present, skipping"
  fi

  if [[ ! -d "$HOME/.tmux/plugins/catppuccin/tmux" ]]; then
    info "Installing catppuccin tmux theme (v2.1.3)..."
    mkdir -p "$HOME/.tmux/plugins/catppuccin"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git \
      "$HOME/.tmux/plugins/catppuccin/tmux"
    ok "catppuccin tmux"
  else
    info "catppuccin tmux — already present, skipping"
  fi
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_tmux
fi
