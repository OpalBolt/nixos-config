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
  };
}
