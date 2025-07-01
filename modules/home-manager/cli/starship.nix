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
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      #settings = pkgs.lib.importTOML ./configfiles/starship-config.toml;
    };
  };
}
