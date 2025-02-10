{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerdfonts
    Iosevka
    fantasque-sans-mono
    mononoki
    ubuntu_font_family
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "FantasqueSansMono"
        "Mononoki"
      ];
    })
  ];
  fontconfig = {
    defaultFonts = {
      monospace = [ "Iosevka NFM:style=Regular" ];
    };
  };

}
