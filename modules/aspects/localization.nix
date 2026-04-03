{ ... }:
{
  # Parametric: reads timezone, locale, kbdLayout from the host's schema attributes.
  den.aspects.localization = {
    includes = [
      ({ host, ... }: {
        nixos = {
          time.timeZone = host.timezone;
          i18n.defaultLocale = host.locale;
          i18n.extraLocaleSettings = {
            LC_ADDRESS = host.extraLocale;
            LC_IDENTIFICATION = host.extraLocale;
            LC_MEASUREMENT = host.extraLocale;
            LC_MONETARY = host.extraLocale;
            LC_NAME = host.extraLocale;
            LC_NUMERIC = host.extraLocale;
            LC_PAPER = host.extraLocale;
            LC_TELEPHONE = host.extraLocale;
            LC_TIME = host.extraLocale;
          };
          services.xserver.xkb.layout = host.kbdLayout;
          console.useXkbConfig = true;
          networking.timeServers = [ "dk.pool.ntp.org" ];
        };
      })
    ];

    homeManager = { ... }: {
      home.keyboard.layout = "dk";
    };
  };
}
