{ lib, config, ... }:

{
  options = {
    feature.cli.generic = {
      enable = lib.mkEnableOption "enable generic apps" // {
        default = true;
      };
      fzf.enable = lib.mkEnableOption "Enables fzf" // {
        default = true;
      };
    };
  };

  config = lib.mkIf config.feature.cli.generic.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

}
