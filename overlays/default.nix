#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let
  # Adds my custom packages
  additions =
    final: prev:
    let
      # Check if pkgs directory exists, otherwise return empty set
      pkgsPath = ../pkgs;
      pkgsExists = builtins.pathExists pkgsPath;
    in
    if pkgsExists then import pkgsPath { pkgs = final; } else { };

  # Linux-specific modifications
  linuxModifications = final: prev: prev.lib.mkIf final.stdenv.isLinux { };

  # Package modifications
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # VS Code extensions overlay
  vscode-extensions = final: prev: {
    vscode-extensions = inputs.nix-vscode-extensions.extensions.${prev.system};
  };

  # Stable packages accessible as pkgs.stable
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  # Unstable packages accessible as pkgs.unstable
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (vscode-extensions final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
