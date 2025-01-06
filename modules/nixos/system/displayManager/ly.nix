{lib, config, ...}:

{
  options.nos.system.displaymanager.ly.enable = 
    lib.mkEnableOption "Enables the ly display manager" // {default = true;};

  config = lib.mkif config.nos.system.displaymanager.ly.enable {
    services.displayManager.ly = {
      enable = true;
    };
  };
}
