{config, lib, vars, ... }:

{
  options = {
    zellij.enable =
      lib.mkEnableOption "Enables Zellij";
  };
  config = lib.mkIf config.zellij.enable {
    xdg.configFile.".config/zellij/config.kdl".source = ./config.kdl;
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
