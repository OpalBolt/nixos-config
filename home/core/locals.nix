{ ... }:
{
  # Keyboard layout synced from NixOS xkb config via osConfig.
  # Falls back to "dk" if osConfig is unavailable (e.g. standalone HM).
  home.keyboard.layout = "dk";
}
