{ pkgs, lib, ... }:
{
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Core font selection - minimal but functional
    noto-fonts
    noto-fonts-emoji
    
    # Programming fonts
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
    
    # UI fonts
    lexend # Highly readable font for interfaces
  ];
}
