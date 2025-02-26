{
  systemd.services.blocky.serviceConfig = {
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    SystemCallFilter = [
      "~@obsolete"
      "~@cpu-emulation"
      "~@swap"
      "~@reboot"
      "~@mount"
    ];
    SystemCallArchitectures = "native";
  };
}
