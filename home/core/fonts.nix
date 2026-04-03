{ pkgs, lib, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.iosevka
    lexend
  ];
}
