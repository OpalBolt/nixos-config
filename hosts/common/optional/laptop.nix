{ pkgs, ... }:
{
  services.power-profiles-daemon.enable = true;
  services.logind.lidSwitch = "suspend-then-hibernate";
  #boot.kernelParams = [ "resume_offset=<offset>" ];
  boot.kernelParams = [
    #"mem_sleep_default=deep"
    "resume_offset=69933056"
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/1dfb6a12-e0b1-4910-8e61-6cb43d9838f7";
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  powerManagement.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32GB in MB
    }
  ];
}
