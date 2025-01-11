{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options = {
    feature.desktop.hyprland.enable = lib.mkEnableOption "Enables the hyprland environment" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.desktop.hyprland.enable {
    programs.hyprland.enable = true;
    programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };
}
