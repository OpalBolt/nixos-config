{
  pkgs,
  ...
}:
{
  programs = {
    yazi.enable = true;
    yazi.enableZshIntegration = true;
    yazi.enableBashIntegration = true;
    yazi.enableFishIntegration = true;
  };
}
