# NixOS Configuration

Personal NixOS configuration files (dotfiles) for my system setup.

## Quick Reference

- **Host:** ceris
- **Window Manager:** Hyprland, River
- **Shell:** zsh
- **Terminal:** kitty
- **Editor:** Neovim

## Todo List

### Overall changes

- [ ] Solaar-flake (already in progress)
- [ ] Update Firefox user styles for better compatibility
- [ ] Zen-browser: youwen5/zen-browser-flake
- [X] Implement nixos hardware settings: nixos/nixos-hardware
- [ ] ensure that XCURSER_SIZE is set
- [ ] Enhance secret management with nix-sops
- [ ] Add unified theming with Stylix integration
- [ ] Create ISO generation capability for system deployment
- [ ] Setup automated backup system to Nextcloud
- [ ] Implement container management solution (Docker or similar)

### Setup changes

- [X] flake.nix should only do nixosConfigurations
- [X] each host should define a username, and by extention do the home-manager fun.
- [X] the hosts files should define everything.
- [ ] Create host specification system for standardized host attributes
- [ ] Implement multi-user support with per-user themes
- [ ] Configure Nextcloud client for automated backups

### Direct changes

- [ ] MOVE: trusted-users to core/default.nix
- [ ] Enhance zsh configuration with custom prompt and improved aliases
- [ ] Add dedicated modules for terminal tools (fastfetch, etc.)
- [ ] Create comprehensive networking module (VPN, firewall settings)
- [ ] Setup modern file manager configuration (yazi or similar)
- [ ] Implement XDG file association management
- [ ] Create sops-nix secret rotation strategy

### Documentation

- [ ] Add architecture overview diagram
- [ ] Create quick reference for frequent commands
- [ ] Document key configuration files and sops-nix usage
- [ ] Add screenshots of desktop environment
- [ ] Document Nextcloud backup configuration and restore procedures