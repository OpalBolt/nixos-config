{
  pkgs,
  config,
  lib,
  ...
}:

{
  options = {
    hm.cli.starship.enable = lib.mkEnableOption "Enables starship" // {
      default = true;
    };
  };

  config = lib.mkIf config.hm.cli.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./configfiles/starship-config.toml;
    };
  };
}
