{ lib, config, ... }:

{
  imports = [
    ./hyprland.nix
    ./../../apps/rofi.nix
    ./../../apps/dunst.nix
  ];

  options = {
    feature.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland and all required apps";
  };

  config = lib.mkIf config.feature.desktop.hyprland.enable {
    feature.apps.rofi.enable = true;
    feature.apps.dunst.enable = true;
  };
}
