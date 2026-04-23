{
  lib,
  pkgs,
  ...
}:

{
  xdg.configFile."zellij/config.kdl".source = lib.custom.relativeToRoot "dotfiles/zellij/config.kdl";
  programs.zellij = {
    package = pkgs.unstable.zellij;
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings.theme = "kanagawa";
    #themes = "kanagawa";
  };
}
