{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.feature.apps.waybar.enable {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
    programs.waybar.enable = true;
    systemd.user.services.waybar = {
      Unit = {
        After = pkgs.lib.mkForce "graphical-session.target";
      };
    };

  };
}
