# Custom Library Functions
# This file extends the standard Nix library with custom functions used throughout the configuration.
# When imported in flake.nix, these functions become available as lib.custom.<function name>

{ lib, ... }:
{
  # Use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  # Scans the given directory for NixOS modules and imports them.
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

}
