{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slack
    timewarrior
    devenv
    devbox
    awscli2
  ];
}
