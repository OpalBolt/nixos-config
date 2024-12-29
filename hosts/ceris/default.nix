{pkgs, ...}:

{
  imports = [
    .hardware-configuration.nix
    ] ++

  hyprland.enable = true;
}

