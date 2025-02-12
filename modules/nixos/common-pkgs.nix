{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.feature.common-pkgs.enable = lib.mkEnableOption "Enables common packages" // {
    default = true;
  };

  config = lib.mkIf config.feature.common-pkgs.enable {

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Remove packages that are not needed
    environment.defaultPackages = lib.mkForce [ ];
    environment.systemPackages = with pkgs; [
      # Archive Managers
      zip # Create and extract ZIP archives
      unzip # Extract ZIP archives
      xz # Compression utilities for .xz and .lzma formats

      # Networking Tools
      wget # Command-line tool for downloading files
      curl # Transfer data from or to a server

      # Editors
      vim # Powerful terminal-based text editor

      # Terminal Emulators
      kitty # Fast, feature-rich GPU-accelerated terminal emulator

      # Version Control
      git # Distributed version control system

      # File Management & Utilities
      file # Determine file types
      tree # Display directory structure in a tree format
      eza # Modern replacement for 'ls' with better formatting
      fd # Fast, user-friendly alternative to 'find'
      bat # Improved 'cat' with syntax highlighting and paging
      ripgrep # Fast recursive search tool (better grep)
      jq # Command-line JSON processor
      yq # Command-line YAML processor
      rsync # Fast incremental file transfer utility

      # System Monitoring & Utilities
      bottom # Modern alternative to 'top' with graphical stats
      util-linux # Essential Linux system utilities (mount, fdisk, etc.)
      pciutils # Tools for inspecting PCI devices
      usbutils # Tools for inspecting USB devices

      # Build & Compilation Tools
      gcc # GNU Compiler Collection (C/C++ compiler)

      # Search & Navigation
      fzf # Fuzzy finder for interactive search
      zoxide # Smarter 'cd' command with jump-to-directory

      # Task & Process Management
      go-task # Simple task runner (like Make but more modern)
      nix-tree # Dependency tree visualizer for Nix packages

      # Desktop & XDG Utilities
      xdg-utils # Generic tools for interacting with the desktop environment
      xdg-launch # CLI for launching XDG-compliant desktop applications

      # Web Browsers
      ungoogled-chromium # Chromium without Google integration

      # Nix-Specific Tools
      nixfmt-rfc-style # Formatter for Nix expressions

      # Wayland Tools
      # nwg-look      # (commented out) Tool for configuring GTK themes in Wayland
      # nwg-displays  # (commented out) Display configuration tool for Wayland
      wl-clipboard # Command-line clipboard utilities for Wayland

      # Communication Tools
      thunderbird # Email client
      weechat # Terminal-based IRC client

    ];

  };
}
