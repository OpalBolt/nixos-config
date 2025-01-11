{ lib, config, ... }:

{
  options.feature.displaymanager.gdm.enable = lib.mkEnableOption "Enables the gdm display manager";

  config = lib.mkIf config.feature.displaymanager.gdm.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
    };
  };
}
