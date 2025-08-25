{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      #nerdfonts
      #Iosevka
      fantasque-sans-mono
      mononoki
      ubuntu_font_family
      nerd-fonts.iosevka
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.mononoki
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka NFM:style=Regular" ];
      };
    };
  };
  environment.variables.XCURSOR_SIZE = "16";
}
