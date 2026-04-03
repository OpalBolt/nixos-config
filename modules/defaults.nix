# Global defaults applied to all hosts.
# Sets up: state versions, lib.custom specialArg, overlays, and common NixOS modules.
{ inputs, lib, ... }:
{
  # Default NixOS state version — individual hosts override via their legacy vars.nix
  den.default.nixos.system.stateVersion = lib.mkDefault "25.05";

  # Override host instantiation to inject lib.custom (relativeToRoot, scanPaths)
  # that legacy modules depend on, plus the standard inputs specialArg.
  den.schema.host = {
    config.instantiate =
      { modules, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = {
          inherit inputs;
          lib = inputs.nixpkgs.lib.extend (
            _: _: {
              custom = import ../lib { lib = inputs.nixpkgs.lib; };
            }
          );
        };
      };
  };

  # Apply overlays and unfree config to all NixOS hosts
  den.default.nixos.nixpkgs.overlays = [
    (import ../overlays { inherit inputs; }).default
    inputs.nix-vscode-extensions.overlays.default
  ];
  den.default.nixos.nixpkgs.config.allowUnfree = true;

  # Common NixOS modules applied to every host
  den.default.nixos.imports = [
    inputs.solaar.nixosModules.default
    inputs.determinate.nixosModules.default
  ];
}
