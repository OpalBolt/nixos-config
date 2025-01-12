{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

{
  options = {
    feature.apps.waybar = {
      enable = lib.mkEnableOption "Enables waybar";
      systemdTarget = lib.mkOption {
        type = lib.types.str;
        default = "graphical-session.target";
        description = "The systemd target to start waybar";
      };
    };
  };

  config = lib.mkIf config.feature.apps.waybar.enable {

    programs.waybar = {
        enable = true;
        systemd.enable = true;
        systemd.target = config.feature.apps.waybar.systemdTarget;
        package = pkgs-unstable.waybar;
      };
  };
}