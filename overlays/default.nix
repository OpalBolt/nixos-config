#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let
  # CUSTOM PACKAGES: Automatically import custom packages from ../pkgs directory
  # This overlay function checks if a "pkgs" directory exists and imports custom packages from it.
  # If no pkgs directory exists, it returns an empty set (no custom packages added).
  additions =
    final: prev:
    let
      pkgsPath = ../pkgs;
    in
    if builtins.pathExists pkgsPath then import pkgsPath { pkgs = final; } else { };

  # UNFREE SOFTWARE: Allow installation of proprietary/unfree packages
  # By default, Nix blocks unfree software. This overlay enables it system-wide.
  # Examples: Discord, VS Code, Spotify, NVIDIA drivers, etc.
  unfree-config = final: prev: {
    config = prev.config // {
      allowUnfree = true;
    };
  };

  # LINUX-SPECIFIC: Framework for Linux-only package modifications
  # Currently empty but provides structure for future Linux-specific customizations.
  # Use this to conditionally apply modifications only on Linux systems.
  linuxModifications =
    final: prev:
    prev.lib.mkIf final.stdenv.isLinux {
      # Add Linux-specific package overrides here when needed
      # Example: someLinuxTool = prev.someLinuxTool.override { enableFeature = true; };
    };

  # PACKAGE OVERRIDES: Customize existing packages with different build options
  # Use this section to modify how existing packages are built or configured.
  modifications = final: prev: {
    # Example of overriding a package with custom attributes:
    # firefox = prev.firefox.override { enableGeckodriver = true; };
    #
    # Example of patching a package:
    # myapp = prev.myapp.overrideAttrs (oldAttrs: {
    #   patches = oldAttrs.patches or [] ++ [ ./my-custom.patch ];
    # });

    # Fix nvim-treesitter-textobjects require check failure
    # The plugin depends on nvim-treesitter which isn't available during build-time checks
    # Override to use master branch instead of the nixpkgs version
  };

  # Stable packages accessible as pkgs.stable
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # Unstable packages accessible as pkgs.unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in
{
  default =
    final: prev:

    (additions final prev)
    // (unfree-config final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
