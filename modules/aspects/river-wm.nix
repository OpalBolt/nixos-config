{ ... }:
{
  den.aspects.river-wm.nixos = { pkgs, ... }: {
    services.displayManager.ly.enable = true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
      wlr.enable = true;
      config.common.default = [ "wlr" ];
    };
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "river";
      XDG_SESSION_DESKTOP = "river";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";
    };
    programs = {
      river-classic.enable = true;
      waybar.enable = true;
    };
    security.pam.services.swaylock = { };
    environment.systemPackages = with pkgs; [
      slurp
      grim
      swappy
      mako
      libnotify
      wideriver
      swayidle
      swaylock
      pavucontrol
      pamixer
      playerctl
      polkit_gnome
      brightnessctl
      wl-clipboard
      swaybg
      wlr-randr
      networkmanagerapplet
      fuzzel
    ];
  };
}
