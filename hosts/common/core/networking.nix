{
  pkgs,
  lib,
  config,
  ...
}:
{
  networking = {
    dhcpcd.enable = false;
    hostName = config.hostSpec.hostname;
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    useDHCP = lib.mkDefault true;
    useHostResolvConf = false;
    usePredictableInterfaceNames = true;
  };
}