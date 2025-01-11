{
  config,
  lib,
  vars,
  ...
}:

{
  options = {
    feature.cli.zellij.enable = lib.mkEnableOption "Enables Zellij" // {
      default = true;
    };
  };
  config = lib.mkIf config.feature.cli.zellij.enable {
    xdg.configFile."zellij/config.kdl".source = ./configfiles/zellij-config.kdl;
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
