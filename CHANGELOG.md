# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Hyprland keybindings for brightness control (`XF86MonBrightnessDown/Up` via `brightnessctl`) and volume control (`XF86AudioMute/LowerVolume/RaiseVolume` via `wpctl`).

### Changed
- `hyprland.lua` reformatted with 2-space indentation throughout.
- `zsh/.zshrc` claude session aliases pruned; `claude_eko` alias added.

### Fixed
- `yazi.toml`: replaced `"$schema"` quoted key (rejected by newer yazi) with `#:schema` taplo comment directive; renamed `name` → `url` in `[open]` rules and all `[plugin]` fetcher/previewer entries; added required `group = "mime"` field to mime fetcher.
- `theme.toml`: renamed `name` → `url` in `[filetype]` fallback rules; commented out `tab_width` (removed from theme schema in newer yazi).
