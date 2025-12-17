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
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
      #config.common.default = [ "*" ];
      config.common.default = [ "wlr" ];
    };
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "river";
    XDG_SESSION_DESKTOP = "river";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    # enable riverwm
    river-classic.enable = true;

    # enable waybar
    waybar.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # Screenshot related apps
    slurp
    grim
    swappy

    # notification manager
    mako
    libnotify

    # Window manager
    wideriver

    # Apps for handling portals
    #xdg-desktop-portal-wlr - Handled by xdg.portal.wlr.enable
    #xdg-desktop-portal-gtk

    # Handling locks and idle times
    swayidle
    swaylock

    # Sound controller
    pavucontrol
    pamixer
    playerctl

    # Misc
    brightnessctl # Brightness control
    wl-clipboard # Wayland clipboard
    swaybg # Wayland background handler
    wlr-randr # Information about monitor position
    networkmanagerapplet # App for controlling networks
    fuzzel # Replacemnet for Rofi
    swaybg # Background handler
  ];
}
