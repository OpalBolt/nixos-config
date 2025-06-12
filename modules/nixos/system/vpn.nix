{ config, ... }:

{
  services.openvpn.servers = {
    officeVPN = {
      config = "config /etc/openvpn/officeVPN.conf";
      autoStart = false;
    };
    jxef = {
      config = config.sops.secrets.openvpn-work.path;
      autoStart = false;
    };
  };
}
