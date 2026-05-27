#!/bin/bash
# scripts/stow.sh — dotfile symlinking via GNU Stow
# Symlinks all active config packages into $HOME.
# Conflicting files are backed up as <file>.bak before stowing.
#
# Run standalone:  bash scripts/stow.sh
# Sourced by:      install_dev_setup.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

# ── Safe stow ─────────────────────────────────────────────────────────────────
_safe_stow() {
  local pkg=$1
  info "Stowing $pkg..."

  local sim_out
  if sim_out=$(stow --target="$HOME" --dir="$DOTFILES_DIR" --simulate "$pkg" 2>&1); then
    stow --target="$HOME" --dir="$DOTFILES_DIR" "$pkg"
    ok "$pkg"
  else
    warn "Conflicts in $pkg — backing up existing files and retrying..."
    # stow prints: "existing target is neither a link nor empty: <relative-path>"
    while IFS= read -r line; do
      local rel_path
      rel_path=$(printf '%s' "$line" | sed 's/.*: //' || true)
      [[ -z "$rel_path" ]] && continue
      local full_path="$HOME/$rel_path"
      if [[ -e "$full_path" && ! -L "$full_path" ]]; then
        mv "$full_path" "${full_path}.bak"
        info "  backed up: ~/$rel_path → ~/${rel_path}.bak"
      fi
    done < <(printf '%s\n' "$sim_out" | grep "existing target")

    stow --target="$HOME" --dir="$DOTFILES_DIR" "$pkg" \
      && ok "$pkg (conflicts backed up)" \
      || warn "Could not fully stow $pkg — check manually"
  fi
}

stow_dotfiles() {
  step "Symlinking dotfiles via stow"

  local -a pkgs
  if [[ "${OS:-}" == "arch" ]]; then
    pkgs=("${ARCH_STOW_PKGS[@]}")
  else
    pkgs=("${MAC_STOW_PKGS[@]}")
  fi

  for pkg in "${pkgs[@]}"; do
    _safe_stow "$pkg"
  done
}

# ── Standalone entry point ────────────────────────────────────────────────────
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  [[ -z "${OS:-}" ]] && detect_os
  stow_dotfiles
fi
