{ config, ... }:
{
  # Timezone and localization settings
  time.timeZone = config.hostSpec.timezone;
  i18n.defaultLocale = config.hostSpec.locale;

  # Additional locale settings for Danish regional formats
  i18n.extraLocaleSettings = {
    LC_ADDRESS = config.hostSpec.extraLocale;
    LC_IDENTIFICATION = config.hostSpec.extraLocale;
    LC_MEASUREMENT = config.hostSpec.extraLocale;
    LC_MONETARY = config.hostSpec.extraLocale;
    LC_NAME = config.hostSpec.extraLocale;
    LC_NUMERIC = config.hostSpec.extraLocale;
    LC_PAPER = config.hostSpec.extraLocale;
    LC_TELEPHONE = config.hostSpec.extraLocale;
    LC_TIME = config.hostSpec.extraLocale;
  };

  # NTP time synchronization servers
  networking.timeServers = [ "dk.pool.ntp.org" ];
}
