{
  config,
  lib,
  ...
}:

{
  options = {
    feature.cli.starship.enable = lib.mkEnableOption "Enables starship" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.cli.starship.enable {
    programs.starship = {
      enable = true;
    };
  };
}
