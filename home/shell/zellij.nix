{ ... }:
{
  xdg.configFile."zellij/config.kdl".source = ../../dotfiles/zellij/config.kdl;
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings.theme = "kanagawa";
  };
}
