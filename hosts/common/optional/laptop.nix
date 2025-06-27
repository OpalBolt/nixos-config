{ pkgs, ... }:
{
  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # power profile daemon
    power-profiles-daemon.enable = true;
  };
}
