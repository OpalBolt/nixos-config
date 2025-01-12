{ lib, config, ... }:

{
  options.feature.displaymanager.ly.enable = lib.mkEnableOption "Enables the ly display manager" // {
    default = true;
  };

  config = lib.mkIf config.feature.displaymanager.ly.enable {
    services.displayManager.ly = {
      enable = true;
    };
  };
}
