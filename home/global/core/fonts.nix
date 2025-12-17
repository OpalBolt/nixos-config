{ pkgs, lib, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Core font selection - minimal but functional
    noto-fonts
    #noto-fonts-emoji
    noto-fonts-color-emoji

    # Programming fonts
    nerd-fonts.iosevka

    # UI fonts
    lexend # Highly readable font for interfaces
  ];
}
