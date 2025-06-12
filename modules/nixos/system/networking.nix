{ config, lib, ... }:

{
  options = {
    feature.networking = {
      enable = lib.mkEnableOption "NetworkManager" // {
        default = true;
      };
      firewall.enable = lib.mkEnableOption "Enables System firewall" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.feature.networking.enable {
    networking.networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
      };
    };

    services.resolved = {
      enable = true;
      fallbackDns = [
        "9.9.9.9"
        "149.112.112.112"
        "8.8.8.8"
      ];
    };
    networking.firewall.enable = config.feature.networking.firewall.enable;
  };
}
