#!/bin/bash
# scripts/zsh.sh — Zsh plugin setup
# Clones zsh-autosuggestions and zsh-syntax-highlighting into ~/.zsh/.
#
# NOTE: Must run BEFORE stow.sh. The repo contains empty stub dirs for these
# plugins so stow doesn't create broken symlinks to empty dirs. Cloning here
# first populates real directories; stow then leaves them untouched.
#
# Run standalone:  bash scripts/zsh.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

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
      info "$name — already present, skipping"
    else
      [[ -d "$target" ]] && rm -rf "$target"   # remove empty stub from a prior stow run
      info "Cloning $name..."
      git clone "$url" "$target"
      ok "$name"
    fi
  done
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_zsh_plugins
fi
