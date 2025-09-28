{ pkgs, ... }:
{

  programs.rbw = {
    enable = true;
  };
  home.packages = with pkgs; [
    bitwarden-desktop
    unstable.rofi-rbw
    pinentry-tty
    wtype
    rofi
  ];
}
