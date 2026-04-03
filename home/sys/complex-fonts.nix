{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    ubuntu-classic
    noto-fonts-color-emoji
    material-symbols
    bemoji
    lexend
    fantasque-sans-mono
    mononoki
    nerd-fonts.iosevka
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.mononoki
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "Ubuntu" ];
      sansSerif = [ "Lexend" ];
      monospace = [ "Iosevka NFM:style=Regular" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
