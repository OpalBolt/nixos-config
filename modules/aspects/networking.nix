{ ... }:
{
  den.aspects.networking.nixos = { lib, ... }: {
    networking = {
      dhcpcd.enable = false;
      networkmanager.enable = true;
      networkmanager.wifi.powersave = true;
      useDHCP = lib.mkDefault true;
      useHostResolvConf = false;
      usePredictableInterfaceNames = true;
    };
    networking.firewall.enable = true;
  };
}
