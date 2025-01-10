{ lib, config, ... }:

{
  imports = [
    ./hyprland.nix
    ./../../apps/rofi.nix
    ./../../apps/dunst.nix
  ];

  options = {
    hm.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland and all required apps";
  };

  config = lib.mkIf config.hm.desktop.hyprland.enable {
    # hm.desktop.hyprland = {
    #   hyprlock.enable = true;
    # };
    hm.apps.rofi.enable = true;
    hm.apps.dunst.enable = true;
  };
}
