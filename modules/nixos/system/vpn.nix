{
  services.openvpn.servers = {
    officeVPN = {
      config = ''config /root/nixos/openvpn/officeVPN.conf '';
    };
  };
}
