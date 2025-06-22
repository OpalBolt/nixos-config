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

### Setup changes

- [ ] flake.nix should only do nixosConfigurations
- [ ] each host should define a username, and by extention do the home-manager fun.
- [ ] the hosts files should define everything.

### Direct changes

- [ ] MOVE: trusted-users to core/default.nix