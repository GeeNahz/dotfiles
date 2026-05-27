#!/bin/bash
# Dotfiles install script — Arch Linux & macOS
# Usage: bash install_dev_setup.sh
#
# Requires sudo only for: pacman/yay installs, adding zsh to /etc/shells.
# Individual modules can also be run standalone — see scripts/ directory.

set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/scripts" && pwd)"

# ── Load shared library + all modules ────────────────────────────────────────
source "$SCRIPTS_DIR/lib.sh"
source "$SCRIPTS_DIR/packages.sh"
source "$SCRIPTS_DIR/zsh.sh"
source "$SCRIPTS_DIR/tmux.sh"
source "$SCRIPTS_DIR/vim.sh"
source "$SCRIPTS_DIR/kitty.sh"
source "$SCRIPTS_DIR/asdf.sh"
source "$SCRIPTS_DIR/stow.sh"
source "$SCRIPTS_DIR/fonts.sh"
source "$SCRIPTS_DIR/shell.sh"

# ── Post-install instructions ─────────────────────────────────────────────────
print_done() {
  printf "\n${BOLD}${GREEN}╔══════════════════════════════════════════════╗${NC}\n"
  printf "${BOLD}${GREEN}║  Done! Restart your terminal to apply all    ║${NC}\n"
  printf "${BOLD}${GREEN}║  changes.                                    ║${NC}\n"
  printf "${BOLD}${GREEN}╚══════════════════════════════════════════════╝${NC}\n\n"
  printf "  Next steps:\n"
  printf "  1. Restart terminal  (or: exec zsh)\n"
  printf "  2. Open tmux → press <prefix> + I  to install tmux plugins\n"
  printf "  3. Open nvim → lazy.nvim auto-installs plugins on first launch\n"
  printf "  4. In nvim → :Codeium Auth  to authenticate AI completion\n"
  if [[ "$OS" == "arch" ]]; then
  printf "  5. Log out and back in to apply Hyprland / Waybar configs\n"
  fi
  printf "\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  printf "\n${BOLD}  Dotfiles install — Arch Linux & macOS${NC}\n"
  printf "  Dotfiles dir: %s\n\n" "$DOTFILES_DIR"

  detect_os

  case "$OS" in
    arch) install_packages_arch ;;
    mac)  install_packages_mac  ;;
  esac

  setup_zsh_plugins   # must precede stow_dotfiles (populates plugin dirs before stow runs)
  setup_tmux
  setup_vim
  setup_kitty_theme
  install_asdf
  install_languages
  stow_dotfiles
  setup_fonts
  change_default_shell
  print_done
}

main
