{
  services.openvpn.servers = {
    officeVPN = {
      config = "config /etc/openvpn/officeVPN.conf";
      autoStart = false;
    };
    jxef = {
      config = "config /etc/openvpn/jxef.opvn";
      autoStart = false;
    };
  };
}
