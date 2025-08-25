# OpalBolt's Nix Configuration

> **Note:** This GitHub repository is a mirror. The primary repository is hosted at:  
> **<https://codeberg.org/OpalBolt/nixos-config>**

A personal NixOS and Home Manager configuration using flakes for declarative system management.

## Features

- **Flake-based configuration** - Modern Nix configuration with reproducible builds
- **Multi-host support** - Configurations for different machines
- **Home Manager integration** - User environment management
- **Modular structure** - Easy to customize and extend
- **Dotfiles management** - Comprehensive dotfiles for development workflow

## Structure

- `flake.nix` - Main entry point for the configuration
- `hosts/` - System-level configurations for different machines
  - `common/` - Shared configurations across hosts
  - `nixos/` - NixOS-specific machine configurations
- `home/` - Home Manager configurations
  - `global/` - Shared user configurations
  - `users/` - User-specific configurations
- `dotfiles/` - Configuration files and scripts
  - `nvim/` - Neovim configuration
  - `scripts/` - Utility scripts
  - `waybar/` - Waybar configuration
  - `zellij/` - Terminal multiplexer configuration
- `lib/` - Custom library functions
- `overlays/` - Package modifications

## Quick Start

1. Clone the repository:

   ```bash
   git clone https://codeberg.org/OpalBolt/nixos-config
   cd nixos-config
   ```

2. Build and switch to the configuration:

   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

3. For Home Manager only:

   ```bash
   home-manager switch --flake .#<username>@<hostname>
   ```

## Requirements

- NixOS 23.11 or later
- Flakes enabled in your Nix configuration

## License

This configuration is provided as-is for reference and learning purposes. See [LICENSE](LICENSE) for details.

---

*Primary repository: <https://codeberg.org/OpalBolt/nixos-config>*

---

<div align="center">
  
  Made with ❤️ by [OpalBolt](https://codeberg.org/OpalBolt)
  
</div>