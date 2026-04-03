# Security hardening for internet-facing or security-critical systems.
# Each setting only improves over kernel defaults.
{ ... }:
{
  den.aspects.hardening.nixos = { lib, ... }: {
    services.fail2ban = {
      enable = lib.mkDefault true;
      maxretry = 5;
      bantime = "24h";
      ignoreIP = [
        "127.0.0.1/8"
        "::1"
      ];
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.rp_filter" = 2;
      "net.ipv4.conf.default.rp_filter" = 2;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;
      "net.ipv4.tcp_syn_retries" = 2;
      "net.ipv4.tcp_synack_retries" = 2;
      "net.ipv4.tcp_max_syn_backlog" = 4096;
      "net.ipv4.tcp_timestamps" = 0;
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      "vm.unprivileged_userfaultfd" = 0;
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.suid_dumpable" = 0;
    };

    boot.kernelParams = [
      "vsyscall=none"
      "pti=on"
      "slab_nomerge"
      "page_alloc.shuffle=1"
    ];

    security.apparmor = {
      enable = true;
      killUnconfinedConfinables = false;
    };

    systemd.coredump.enable = false;
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "core";
        value = "0";
      }
    ];

    system.autoUpgrade = {
      enable = lib.mkDefault true;
      allowReboot = lib.mkDefault false;
      dates = "daily";
      randomizedDelaySec = "45min";
    };
  };
}
