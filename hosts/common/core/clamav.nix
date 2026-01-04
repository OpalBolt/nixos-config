{ _, ... }:
{
  # ClamAV antivirus - baseline security for all systems
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "hourly";
  };
}
