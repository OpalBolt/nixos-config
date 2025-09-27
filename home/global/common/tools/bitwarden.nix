{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
    keyutils
    rofi
  ];
}
