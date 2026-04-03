# den.schema.host — host-level metadata options.
# These mirror the subset of hostSpec flags that den aspects will use
# to conditionally apply features. Full hostSpec stays in the legacy
# NixOS option (new-modules/common/default.nix) until Phase 3.
{ lib, ... }:
{
  den.schema.host =
    { lib, config, ... }:
    {
      options = {
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Host uses work resources (VPN, work-wifi, work apps)";
        };
        isMinimal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Minimal installation — no GUI, limited packages";
        };
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Server host — implies minimal + openssh + hardening";
        };
        useWindowManager = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Host runs a Wayland window manager (River, GNOME, etc.)";
        };
        primaryUser = lib.mkOption {
          type = lib.types.str;
          default = "mads";
          description = "Name of the primary user on this host";
        };
      };

      # Servers are always minimal
      config.isMinimal = lib.mkIf config.isServer true;
    };
}
