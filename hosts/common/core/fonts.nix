{ pkgs, lib, ... }:
{
  fonts = {
    packages = with pkgs; [
      # --- System and General Purpose Fonts ---
      noto-fonts # Google's font family for international text
      ubuntu_font_family # Ubuntu's official font family

      # --- Special Character and Emoji Fonts ---
      noto-fonts-emoji # Google's emoji font
      material-symbols # Google's Material Design icons

      # --- Sans-Serif Fonts ---
      lexend # Highly readable font designed to reduce visual stress

      # --- Monospace Fonts ---
      fantasque-sans-mono # Regular version of the playful coding font
      mononoki # Font for programming, with clear distinctions between similar characters

      # --- Nerd Fonts (patched with extra glyphs) ---
      nerd-fonts.iosevka # Highly customizable, narrow programmer's font
      nerd-fonts.fantasque-sans-mono # Nerd Font version of Fantasque Sans Mono
      nerd-fonts.mononoki # Nerd Font version of Mononoki
    ];

    # Disable default font packages as they can interfere with custom configuration
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Lexend" ];
        monospace = [
          "Iosevka NFM"
          "Fantasque Sans Mono Nerd Font"
          "Mononoki Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
