# Network configuration for Pangolin DMZ server
# Static IP: 192.168.106.10/24 in VLAN 30 (DMZ)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    # Static IP in DMZ VLAN 30
    useDHCP = false;
    interfaces.ens18 = {
      # Adjust interface name for your hardware
      ipv4.addresses = [
        {
          address = "192.168.106.10";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.106.1";
    nameservers = [
      "192.168.106.1"
      "1.1.1.1"
    ];

    # Firewall - allow HTTP/HTTPS from internet, SSH from LAN only
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 51820 ]; # WireGuard for Pangolin/Gerbil

      # Restrict SSH to LAN network only
      extraCommands = ''
        iptables -A nixos-fw -p tcp --dport 22 -s 192.168.104.0/24 -j nixos-fw-accept
      '';
    };
  };

  # Enable IP forwarding for reverse proxy
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1; # default: 0
}
