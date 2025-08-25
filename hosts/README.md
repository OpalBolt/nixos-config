# Host Configuration

## Overview

This directory contains NixOS host configurations following the KISS principle (Keep It Simple, Stupid).

## Host Configuration Structure

Each host should follow this structure:

```text
hosts/
  HOSTNAME/                    # Your hostname (e.g., ceris)
    default.nix                # Main configuration file with imports and variable validation
    hardware-configuration.nix # Hardware-specific configuration
    home.nix                   # (Optional) Home manager configuration
    config/                    # Host-specific configuration
      default.nix              # Imports all files in this directory
      vars.nix                 # ALL variables defined in one place
      secrets.nix              # (Optional) Secret handling
      ...                      # Other configuration files
```

## Creating a New Host

To create a new host:

1. Create a directory with your hostname: `mkdir -p hosts/HOSTNAME/config`
2. Copy hardware-configuration.nix from your system: `sudo nixos-generate-config --show-hardware-config > hosts/HOSTNAME/hardware-configuration.nix`
3. Create a minimal default.nix:

```nix
{ lib, config, ... }:
{
  imports = lib.flatten [
    ./config
    ./hardware-configuration.nix

    # Add specific hardware modules if needed
    # inputs.hardware.nixosModules.common-pc-laptop-ssd

    (map lib.custom.relativeToRoot [
      "modules-nix/core"
      # Add other modules as needed
    ])
  ];
  
  # Validate all variables
  systemVars = lib.custom.vars.validateSystemVars config.systemVars;
  userVars = lib.custom.vars.validateUserVars config.userVars;
  
  # Other host-specific configuration
  system.stateVersion = "24.11";
}
```

4. Create a config/default.nix:

```nix
{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
```

5. Create a config/vars.nix with ALL your variables:

```nix
{ config, lib, ... }:
{
  systemVars = {
    hostname = "your-hostname";
    system = "x86_64-linux";
    # Add other system variables
  };
  
  userVars = {
    userName = "your-username";
    name = "Your Name";
    fullName = "Your Full Name";
    # Add other user variables
    
    # Secret-dependent variables example:
    email = lib.mkIf (config.sops.secrets ? email) 
      config.sops.secrets.email.path;
  };
}
```

All variables are defined in one place and properly validated!


## Program categorization

- web (browsers, web apps, internet tools)
- comms (chat, email, collaboration)
- desktop (window managers, desktop environments, UI customization)
- dev (programming languages, compilers, IDEs)
- editors (text editors, code editors)
- media (audio, video, images)
- net (networking, VPN, connectivity)
- office (documents, productivity)
- shell (terminals, shells, CLI tools)
- sys (system services, daemons)
- security (authentication, encryption, permissions)
- theme (visual styling, fonts, icons)
- tools (utilities, file managers)
- virt (virtualization, containers)
