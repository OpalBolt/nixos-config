{ den, ... }:
{
  # Typed options available on every host via host.* in parametric aspects
  den.schema.host = { lib, ... }: {
    options = {
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "System timezone (e.g. Europe/Copenhagen)";
      };
      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "Primary locale";
      };
      extraLocale = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "Extra locale for regional format settings";
      };
      kbdLayout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "X11 keyboard layout";
      };
      consoleKbdKeymap = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Console keyboard keymap";
      };
      isWork = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this is a work machine (enables work-specific config)";
      };
      primaryUser = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Primary user login name (for group membership, etc.)";
      };
      flakePath = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nixos";
        description = "Absolute path to the NixOS flake (used by nh)";
      };
    };
  };
}
