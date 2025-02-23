{
  systemd.services.clamav-daemon.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = "read-only";
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectKernelGroups = true;
    ReadWritePaths = "/var/log/";
    SystemCallFilter = [
      "~@clock"
      "~@reboot"
      "~@debug"
      "~@module"
      "~@swap"
      "~@obsolete"
      "~@cpu-emulation"
      "~@mount"
      "~@privileged"
      "~@raw-io"
      "~@resources"
    ];
  };
}
