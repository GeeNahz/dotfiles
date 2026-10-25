# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-10-25

### Added
- Hyprland keybindings for brightness control (`XF86MonBrightnessDown/Up` via `brightnessctl`) and volume control (`XF86AudioMute/LowerVolume/RaiseVolume` via `wpctl`).
- `zsh/.zshrc`: added `claude_subtrack`, `claude_portfolio`, and `claude_keepsake` session aliases.

### Changed
- `hyprland.lua`: brightness step reduced from 5% to 1% per keypress for finer control.
- `hyprland.lua`: reformatted with 2-space indentation throughout.
- `starship.toml`: raise `scan_timeout` to 1000ms and `command_timeout` to 20000ms for headroom on complex directories.
- `starship.toml`: re-enable `[package]` module (`disabled = false`).
- `starship.toml`: strip leading space from all `[os.symbols]` icon strings for tighter prompt alignment.
- `starship.toml`: remove leading space from `[username]` format string (`[ $user ]` → `[$user ]`).
- `starship.toml`: increase `[directory]` `truncation_length` from 20 to 25 characters.
- `conform.lua`: switch from `format_on_save` (synchronous, blocked editor) to `format_after_save` (async, non-blocking) to remove save freeze and cursor hold.
- `zsh/.zshrc`: use `compinit -C` to skip the per-shell security check and use the cached completion dump.
- `zsh/.zshrc`: claude session aliases pruned; `claude_eko` alias added.
- `lsp-zero.lua`: reformat from tab to 2-space indentation.

### Fixed
- `hyprland.lua`: fix typo `hyrctl` → `hyprctl` in autostart exec.
- `yazi.toml`: replace `"$schema"` quoted key with `#:schema` taplo comment directive; rename `name` → `url` in `[open]` rules and all `[plugin]` fetcher/previewer entries; add required `group = "mime"` field to mime fetcher.
- `theme.toml`: rename `name` → `url` in `[filetype]` fallback rules; comment out `tab_width` (removed from theme schema in newer yazi).
- `lsp-zero.lua`: comment out `MasonToolsInstall` auto-run on startup (was checking/downloading tools on every nvim launch).
- `lsp-zero.lua`: comment out `pylsp` — conflicts with `pyright`, two LSPs attaching to every Python file.
- `lsp-zero.lua`: comment out `nextls` — conflicts with `elixirls`, two LSPs attaching to every Elixir file.
- `nvim-treesitter.lua`: comment out explicit `configs.install()` call — `auto_install = true` already covers parser installation.
- `starship.toml`: reduce `scan_timeout` from 10 000ms to 100ms and `command_timeout` from ~infinite to 2 000ms to fix prompt stalling after `cd`.
