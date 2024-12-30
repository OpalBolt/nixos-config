{config, lib, ... }:

with lib;

{
  options = {
    gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.gnome.enable) {
    services = {
      xserver = {
        displayManager.gdm.enable = true;
	desktopManager.gnome.enable = true;
      };
    };
  };
}
