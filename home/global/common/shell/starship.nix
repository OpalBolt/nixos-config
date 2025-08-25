{
  config,
  lib,
  ...
}:

{

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
