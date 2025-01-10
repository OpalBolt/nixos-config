{ config, lib, ... }:

{
  options = {
    nos.system.networking = {
      enable = lib.mkEnableOption "NetworkManager" // {
        default = true;
      };
      firewall.enable = lib.mkEnableOption "Enables System firewall" // {
        default = true;
      };
      ssh.enable = lib.mkEnableOption "Enables incomming SSH connections";
    };
  };

  config = lib.mkIf config.nos.system.networking.enable {
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
    networking.firewall.enable = config.nos.system.networking.firewall.enable;

    services.openssh.enable = config.nos.system.networking.ssh.enable;
  };
}
