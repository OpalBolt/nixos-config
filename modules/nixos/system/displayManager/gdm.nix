{ lib, config, ... }:

{
  options.nos.system.displaymanager.gdm.enable = lib.mkEnableOption "Enables the gdm display manager";

  config = lib.mkIf config.nos.system.displaymanager.gdm.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
    };
  };
}
