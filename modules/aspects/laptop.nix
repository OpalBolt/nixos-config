# Laptop power management. Resume device UUID is rosi-specific and set here
# since this config is only included from the rosi host aspect.
{ ... }:
{
  den.aspects.laptop.nixos = { ... }: {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
      HandlePowerKey = "hibernate";
    };
    services.power-profiles-daemon.enable = true;
    boot.kernelParams = [ "resume_offset=69933056" ];
    boot.resumeDevice = "/dev/disk/by-uuid/1dfb6a12-e0b1-4910-8e61-6cb43d9838f7";
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';
    powerManagement.enable = true;
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 32 * 1024;
      }
    ];
  };
}
