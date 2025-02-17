{
  config,
  lib,
  ...
}:

{
  options = {
    feature.apps.mako.enable = lib.mkEnableOption "Enables mako" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.apps.mako.enable {
    programs.mako = {
      enable = true;
      defaultTimeout = 5000;
    };
  };
}
