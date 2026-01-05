{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  # Import the home-manager NixOS module
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home-manager configuration for non-minimal systems
  # This module should be imported by hosts that need home-manager (rosi, ceris, scopuli)
  # and NOT imported by minimal hosts (tynan)
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit pkgs inputs;
      inherit (config) hostSpec;
    };
    users = {
      root.home.stateVersion = "24.05";
      ${config.hostSpec.username}.imports = [
        (lib.custom.relativeToRoot "home/users/${config.hostSpec.username}/${config.hostSpec.hostname}.nix")
      ];
    };
  };
}
