#!/bin/bash
# scripts/asdf.sh — asdf version manager + language installs
# Installs asdf via git, then installs: Node.js, Python, Erlang, Elixir.
#
# Run standalone:  bash scripts/asdf.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

# ── asdf install ──────────────────────────────────────────────────────────────
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

# ── asdf helpers ──────────────────────────────────────────────────────────────
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
    info "$plugin $version — already installed, skipping"
  else
    info "Installing $plugin $version (this may take a while)..."
    asdf install "$plugin" "$version"
  fi

  asdf global "$plugin" "$version"
  ok "$plugin $version → global"
}

# ── Language installs ─────────────────────────────────────────────────────────
install_languages() {
  step "Installing languages via asdf"
  _load_asdf

  _plugin_add nodejs
  _install_lang nodejs

  _plugin_add python
  _install_lang python

  # Erlang: build deps are installed during the packages step
  info "Installing Erlang — compilation takes 10–20 min on first run..."
  _plugin_add erlang
  if [[ "${OS:-}" == "mac" ]]; then
    # Point asdf-erlang to Homebrew's openssl
    export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
  fi
  _install_lang erlang

  _plugin_add elixir
  _install_lang elixir

  ok "All languages installed"
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  [[ -z "${OS:-}" ]] && detect_os
  install_asdf
  install_languages
fi
