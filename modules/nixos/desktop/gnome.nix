# { vars, ...}:
#
# let 
#   moduleTemplate = import ../../../../templates/moduleTemplate.nix;
# in
#   moduleTemplate {
#     name = "gnome";
#     enableDescription = "enables the Gnome desktop enviroment";
#     configContent = {
#       services.xserver = {
#         displayManager.gdm.enable = true;
#         desktopManager.gnome.enable = true;
#         xkb = {
#           layout = vars.kbdLayout;
#           variant = "";
#         };
#       };
#     };
#   }
{ config, vars, lib, ... }:

{
  options = {
    nos.dekstop.gnome.enable = lib.mkEnableOption "Enables the Gnome desktop environment";
  };

  config = lib.mkIf config.nos.desktop.enable {
    services.xserver = {
      #displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = vars.kbdLayout or "dk";  # Default to "us" if the layout is not specified
        variant = "";
      };
    };
  };
}
