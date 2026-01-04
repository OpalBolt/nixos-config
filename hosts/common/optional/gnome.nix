{ pkgs, ... }:

{

  services.displayManager.ly = {
    enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      # Extra portals handled by the xdg-portal.wlr.enable
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        #xdg-desktop-portal-gtk
      ];
    };
  };
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = (
    with pkgs;
    [
      atomix # puzzle game
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
    ]
  );
  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

}
