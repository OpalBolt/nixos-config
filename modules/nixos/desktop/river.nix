{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.feature.desktop.river.enable {
    environment.systemPackages = with pkgs; [

      # Screenshot related apps
      slurp
      grim
      swappy

      # notification manager
      mako
      libnotifier

      # Window manager
      wideriver

      # Apps for handling portals
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk

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

    ];
  };

}
