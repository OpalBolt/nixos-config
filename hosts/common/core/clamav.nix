{
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    pkgs.clamav

  ];

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "hourly";
  };
}
