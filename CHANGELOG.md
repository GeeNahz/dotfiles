# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- `starship.toml`: reduce `scan_timeout` from 10 000ms to 100ms and `command_timeout` from ~infinite to 2 000ms to fix prompt stalling after `cd`.
- `conform.lua`: switch from `format_on_save` (synchronous, blocked editor) to `format_after_save` (async, non-blocking) to remove save freeze and cursor hold.
- `zsh/.zshrc`: use `compinit -C` to skip the per-shell security check and use the cached completion dump.

### Fixed
- `lsp-zero.lua`: comment out `MasonToolsInstall` auto-run on startup (was checking/downloading tools on every nvim launch).
- `lsp-zero.lua`: comment out `pylsp` from `ensure_installed` — it conflicts with `pyright`, causing two LSPs to attach to every Python file.
- `nvim-treesitter.lua`: comment out explicit `configs.install()` call — `auto_install = true` in `setup()` already covers parser installation.

### Added
- Hyprland keybindings for brightness control (`XF86MonBrightnessDown/Up` via `brightnessctl`) and volume control (`XF86AudioMute/LowerVolume/RaiseVolume` via `wpctl`).

### Changed
- `hyprland.lua` reformatted with 2-space indentation throughout.
- `zsh/.zshrc` claude session aliases pruned; `claude_eko` alias added.

### Fixed
- `yazi.toml`: replaced `"$schema"` quoted key (rejected by newer yazi) with `#:schema` taplo comment directive; renamed `name` → `url` in `[open]` rules and all `[plugin]` fetcher/previewer entries; added required `group = "mime"` field to mime fetcher.
- `theme.toml`: renamed `name` → `url` in `[filetype]` fallback rules; commented out `tab_width` (removed from theme schema in newer yazi).
