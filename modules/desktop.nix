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
    hm.desktop.hyprland.enable = true;
    #desktop.enableGnome = false;
  };
}
