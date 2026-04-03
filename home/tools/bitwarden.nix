{ pkgs, ... }:
{
  programs.rbw.enable = true;
  home.packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
    unstable.rofi-rbw
    pinentry-tty
    wtype
    rofi
  ];
}
