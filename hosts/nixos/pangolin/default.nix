# Pangolin reverse proxy server
# DMZ network: 192.168.106.0/24
{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    ./config
    ./hardware-configuration.nix

    (map lib.custom.relativeToRoot [
      "hosts/common/core"
      "hosts/common/optional/openssh.nix"
      "hosts/common/optional/hardening.nix"
    ])
  ];

  networking.hostName = config.hostSpec.hostname;

  # Server-specific packages
  environment.systemPackages = with pkgs; [
    htop
    tcpdump
    curl
    dig
  ];

  system.stateVersion = "25.11";
}
