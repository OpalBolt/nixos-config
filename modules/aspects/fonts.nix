{ ... }:
{
  den.aspects.fonts = {
    nixos = { pkgs, ... }: {
      fonts = {
        packages = with pkgs; [
          fantasque-sans-mono
          mononoki
          ubuntu-classic
          nerd-fonts.iosevka
          nerd-fonts.fantasque-sans-mono
          nerd-fonts.mononoki
          material-symbols
          lexend
          noto-fonts
          noto-fonts-color-emoji
        ];
        fontconfig = {
          defaultFonts = {
            monospace = [ "Iosevka NFM:style=Regular" ];
            serif = [ "Ubuntu" ];
            sansSerif = [ "Lexend" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
      environment.variables.XCURSOR_SIZE = "16";
    };

    homeManager = { pkgs, ... }: {
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "Iosevka NFM:style=Regular" ];
          serif = [ "Ubuntu" ];
          sansSerif = [ "Lexend" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
      home.packages = with pkgs; [
        bemoji
        fantasque-sans-mono
        mononoki
      ];
    };
  };
}
