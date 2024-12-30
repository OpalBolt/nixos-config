{config, lib, vars, ... }:

{
  options = {
    gnome.enable = 
      lib.mkEnableOption "Enables Gnome desktop enviroment";
  };

  config = lib.mkIf config.gnome.enable {
    services = {
      xserver = {
        displayManager.gdm.enable = true;
	desktopManager.gnome.enable = true;
        xkb = {
          layout = vars.kbdLayout;
          variant = "";
        };
      };
    };
  };
}
