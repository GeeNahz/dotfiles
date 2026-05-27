#!/bin/bash
# scripts/shell.sh — default shell configuration
# Changes the user's default shell to zsh.
# Registers the zsh path in /etc/shells if not already present (requires sudo).
#
# Run standalone:  bash scripts/shell.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

change_default_shell() {
  step "Setting Zsh as default shell"

  local zsh_path
  zsh_path=$(command -v zsh 2>/dev/null) || { warn "zsh not in PATH — skipping"; return; }

  if [[ "${SHELL:-}" == *zsh* ]]; then
    info "Already using zsh — skipping"
    return
  fi

  if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    info "Registering $zsh_path in /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  chsh -s "$zsh_path"
  ok "Default shell → $zsh_path"
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  change_default_shell
fi
