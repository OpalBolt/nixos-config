{ ... }:
{
  den.aspects.fonts.nixos = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        fantasque-sans-mono
        mononoki
        ubuntu-classic
        nerd-fonts.iosevka
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.mononoki
      ];
      fontconfig.defaultFonts.monospace = [ "Iosevka NFM:style=Regular" ];
    };
    environment.variables.XCURSOR_SIZE = "16";
  };
}
