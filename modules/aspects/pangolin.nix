# pangolin aspect — physical server in DMZ, reverse proxy.
# Minimal: no GUI, no HM, openssh + hardening only.
{ den, inputs, ... }:
{
  den.aspects.pangolin = {
    includes = [
      den.aspects.core
      den.aspects.openssh
      den.aspects.hardening
    ];

    nixos =
      { lib, pkgs, ... }:
      {
        imports = [
          (lib.custom.relativeToRoot "hosts/nixos/pangolin/hardware-configuration.nix")
          (lib.custom.relativeToRoot "hosts/nixos/pangolin/config")
        ];
        environment.systemPackages = with pkgs; [ htop tcpdump curl dig ];
        system.stateVersion = "25.11";
      };
  };
}
