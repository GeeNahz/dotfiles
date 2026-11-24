#!/bin/bash
# scripts/asdf.sh — asdf version manager + language installs
# Installs asdf via yay (Arch) or Homebrew (macOS), then installs: Node.js, Python, Erlang, Elixir.
#
# Run standalone:  bash scripts/asdf.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

# ── asdf install ──────────────────────────────────────────────────────────────
install_asdf() {
  step "Installing asdf"

  # asdf >= 0.16 is a compiled binary — cloning the repo no longer installs it.
  case "${OS:-}" in
    arch)
      command -v yay &>/dev/null || die "yay not found — run scripts/packages.sh first"
      yay -S --needed --noconfirm asdf-vm
      ;;
    mac)
      command -v brew &>/dev/null || die "Homebrew not found — run scripts/packages.sh first"
      if brew list --formula asdf &>/dev/null; then
        info "asdf already installed"
      else
        brew install asdf
      fi
      ;;
    *) die "Cannot install asdf: unsupported OS '${OS:-unset}'" ;;
  esac
  ok "asdf installed"
}

# ── asdf helpers ──────────────────────────────────────────────────────────────
_load_asdf() {
  # This script doesn't read .zshrc, so put the shims on PATH here
  # (e.g. Elixir needs to find the asdf-installed Erlang).
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
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

  asdf set --home "$plugin" "$version"
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
