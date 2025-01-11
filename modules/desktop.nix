{
  vars,
  lib,
  config,
  nixpkgs,
  ...
}:

{
  imports = [
    #./nixos/desktop/gnome
    ./home-manager/desktop/hyprland
  ];

  config = {
    feature.desktop.hyprland.enable = true;
    #desktop.enableGnome = false;
  };
}
