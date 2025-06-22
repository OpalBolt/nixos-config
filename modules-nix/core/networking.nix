{
  pkgs,
  lib,
  config,
  ...
}:
{
  networking = {
    dhcpcd.enable = false;
    hostName = config.systemVars.hostname;
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    useDHCP = lib.mkDefault true;
    useHostResolvConf = false;
    usePredictableInterfaceNames = true;
  };
}