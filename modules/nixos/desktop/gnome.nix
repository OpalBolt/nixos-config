{
  config,
  vars,
  lib,
  ...
}:

{
  options = {
    feature.desktop.gnome.enable = lib.mkEnableOption "Enables the Gnome desktop environment";
  };

  config = lib.mkIf config.feature.desktop.gnome.enable {
    services.xserver = {
      #displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = vars.kbdLayout or "dk"; # Default to "us" if the layout is not specified
        variant = "";
      };
    };
  };
}
