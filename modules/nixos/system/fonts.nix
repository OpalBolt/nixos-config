{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerdfonts
    Iosevka
    fantasque-sans-mono
    mononoki
  ];
  fontconfig = {
    defaultFonts = {
      monospace = [ "Iosevka NFM:style=Regular" ];
    };
  };

}
