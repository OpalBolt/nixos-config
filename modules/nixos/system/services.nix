{ pkgs, ... }:
{
  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver.enable = false;

    # enable firmware udpate daemon
    fwupd.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
    ];

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # ssh server
    openssh.enable = false;

    # power profile daemon
    power-profiles-daemon.enable = true;

    # start keyring
    gnome.gnome-keyring.enable = true;
  };
}
