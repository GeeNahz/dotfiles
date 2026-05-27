#!/bin/bash
# scripts/vim.sh — Vim plugin manager setup
# Installs vim-plug to ~/.vim/autoload/plug.vim.
#
# Run standalone:  bash scripts/vim.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

setup_vim() {
  step "Setting up Vim"
  local plug="$HOME/.vim/autoload/plug.vim"

  if [[ ! -f "$plug" ]]; then
    info "Installing vim-plug..."
    curl -fLo "$plug" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "vim-plug installed"
  else
    info "vim-plug — already present, skipping"
  fi
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_vim
fi
