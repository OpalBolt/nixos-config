{config, ...}:

{
  # Wireless is not enabled as network manager handles wifi functionality
  #networking.wireless.enable = true;

  # Wifi power saving
  # Specified in this document: https://wiki.nixos.org/wiki/NetworkManager
  networking.networkmanager.wifi.powersave = true;
}
