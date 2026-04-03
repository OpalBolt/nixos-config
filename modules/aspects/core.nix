# Core aspect — loaded by every host.
# Wraps hosts/common/core/ which provides:
#   boot, clamav, firewall, keyboard, locals, security, sops, ssh, user
# Also loads new-modules/common (hostSpec NixOS option definitions).
{ ... }:
{
  den.aspects.core.nixos =
    { config, lib, ... }:
    {
      imports = [ ../../hosts/common/core ];
      # Every host sets its network hostname from the hostSpec option
      networking.hostName = lib.mkDefault config.hostSpec.hostname;
    };
}
