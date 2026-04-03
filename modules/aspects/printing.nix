{ ... }:
{
  den.aspects.printing.nixos = { pkgs, ... }: {
    services = {
      printing.enable = true;
      printing.drivers = with pkgs; [
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
        gutenprint
        gutenprintBin
      ];
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
    systemd.services.cups-browsed.enable = true;
  };
}
