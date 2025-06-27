{ pkgs, ... }:
{
  services = {
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
      openFirewall = false;
    };
  };

  systemd.services.cups-browsed = {
    enable = false;
    unitConfig.Mask = true;
  };
}
