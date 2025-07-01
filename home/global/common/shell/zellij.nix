{
  lib,
  ...
}:

{
  xdg.configFile."zellij/config.kdl".source = lib.custom.relativeToRoot "dotfiles/zellij/config.kdl";
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings.theme = "kanagawa";
    themes = "kanagawa";
  };
}
