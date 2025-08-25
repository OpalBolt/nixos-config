{ pkgs, ... }:
{
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.brgenml1cupswrapper
      pkgs.gutenprint
      pkgs.gutenprintBin
    ];

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  systemd.services.cups-browsed = {
    enable = true;
    #unitConfig.Mask = true;
  };
}
