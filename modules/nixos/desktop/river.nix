{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    feature.desktop.river.enable = lib.mkEnableOption "Enable river and all required apps";
    default = true;
  };

  config = lib.mkIf config.feature.desktop.river.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
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
    };

    programs = {
      # enable riverwm
      river.enable = true;

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
      xdg-desktop-portal-wlr
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
  };

}
