{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 56.04;
    longitude = 12.6;
    tray = true;
  };

  home.packages = with pkgs; [
    gammastep
    #make
    kdePackages.okular
  ];
}
