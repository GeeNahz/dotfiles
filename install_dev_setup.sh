#!/bin/bash

set -e

echo "=== INSTALL BASIC DEV SETUP ==="
DEFAULT_PACKAGE_MGR=pacman
# Initial setup:
# -- check for system type (mac, linux type)
# -- set default package manager
# -- install some basic stuffs
# -- -- nodejs
# -- -- python
# -- -- docker*

# Individual scripts for each setup
# Scripts files in ./scripts/ dir

# Setup zsh
# -- auto-completions
# -- auto-suggetions
# -- syntax-highlighting
# Setup starship
# Setup nvim
# Setup vim
# Setup yazi
# Setup tmux
# -- catppuccin theme
# -- tpm setup
# Source .zshrc

echo "=== SETUP COMPLETE ==="
