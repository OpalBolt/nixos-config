# Security hardening configuration for NixOS systems
# Use this module for internet-facing or security-critical systems
#
# This module only sets values that IMPROVE security over kernel defaults.
# Each setting includes the default value and explanation of why we override it.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Fail2ban - Intrusion Prevention System
  # Monitors log files and bans IPs that show malicious behavior (repeated failed logins, etc.)
  services.fail2ban = {
    enable = lib.mkDefault true;
    maxretry = 5; # Number of failures before ban
    bantime = "24h"; # How long to ban malicious IPs
    ignoreIP = [
      "127.0.0.1/8" # Never ban localhost
      "::1" # Never ban IPv6 localhost
    ];
  };

  # Kernel hardening parameters via sysctl
  boot.kernel.sysctl = {

    ## Network Security - Anti-Spoofing Protection ##
    # Prevents IP spoofing attacks by validating that packets came from the expected interface

    "net.ipv4.conf.all.rp_filter" = 1; # default: 0 (disabled) - Enable strict reverse path filtering
    "net.ipv4.conf.default.rp_filter" = 1; # default: 0 (disabled) - Apply to new interfaces

    ## Network Security - Disable Dangerous ICMP Features ##
    # Prevents attackers from manipulating routing tables or learning network topology

    "net.ipv4.conf.all.accept_redirects" = 0; # default: 1 (enabled for hosts) - Ignore ICMP redirects
    "net.ipv4.conf.default.accept_redirects" = 0; # default: 1 (enabled for hosts) - Apply to new interfaces
    "net.ipv4.conf.all.secure_redirects" = 0; # default: 1 (enabled) - Don't accept ICMP redirects from gateways
    "net.ipv4.conf.default.secure_redirects" = 0; # default: 1 (enabled) - Apply to new interfaces

    ## Network Security - Disable Source Routing ##
    # Source routing allows sender to specify the route packets take through the network
    # This can be used to bypass security controls

    "net.ipv4.conf.all.accept_source_route" = 0; # default: 1 for routers, 0 for hosts - Disable source routing
    "net.ipv4.conf.default.accept_source_route" = 0; # default: 1 for routers, 0 for hosts - Apply to new interfaces

    ## Network Security - Enable Logging of Suspicious Packets ##
    # Log packets with impossible source addresses (helps detect attacks)

    "net.ipv4.conf.all.log_martians" = 1; # default: 0 (disabled) - Log martian packets
    "net.ipv4.conf.default.log_martians" = 1; # default: 0 (disabled) - Apply to new interfaces

    ## TCP Hardening - Reduce Attack Surface for SYN Floods ##
    # Reduces the time spent trying to establish connections to potentially malicious hosts

    "net.ipv4.tcp_syn_retries" = 2; # default: 6 (~67 seconds) - Reduce to ~7 seconds
    "net.ipv4.tcp_synack_retries" = 2; # default: 5 (~31 seconds) - Reduce to ~7 seconds
    "net.ipv4.tcp_max_syn_backlog" = 4096; # default: varies by RAM - Set explicit high limit

    ## TCP Privacy - Disable Timestamps ##
    # TCP timestamps can be used for clock fingerprinting and uptime detection
    # Trade-off: Disabling can slightly reduce performance in high-latency networks

    "net.ipv4.tcp_timestamps" = 0; # default: 1 (enabled) - Disable for privacy

    ## Kernel Security - Restrict Kernel Information Leaks ##
    # Prevents unprivileged users from reading kernel memory addresses
    # Makes exploit development significantly harder

    "kernel.kptr_restrict" = 2; # default: 0 (no restriction) - Hide kernel pointers even from root
    "kernel.dmesg_restrict" = 1; # default: 0 (unrestricted) - Restrict dmesg to CAP_SYSLOG

    ## Kernel Security - Disable Dangerous Kernel Features ##
    # Prevents unprivileged users from using advanced kernel features that could aid exploits

    "kernel.unprivileged_bpf_disabled" = 1; # default: 0 (allowed) - Disable unprivileged BPF
    "vm.unprivileged_userfaultfd" = 0; # default: 1 (allowed) - Disable userfaultfd for non-root

    ## File System Security - Hardlink/Symlink Protection ##
    # Prevents certain classes of TOCTOU (time-of-check-time-of-use) race condition attacks
    # Stops users from creating hardlinks/symlinks to files they don't own

    "fs.protected_hardlinks" = 1; # default: 1 (enabled) - Already secure, explicitly set
    "fs.protected_symlinks" = 1; # default: 1 (enabled) - Already secure, explicitly set
    "fs.protected_regular" = 2; # default: 0 (disabled) - Protect regular files in sticky directories
    "fs.protected_fifos" = 2; # default: 0 (disabled) - Protect FIFOs in sticky directories
    "fs.suid_dumpable" = 0; # default: 0 (disabled) - Prevent core dumps of setuid programs
  };

  # Boot kernel parameters for hardware-level security
  boot.kernelParams = [
    # Disable legacy vsyscall (deprecated syscall mechanism with security issues)
    "vsyscall=none" # default: emulate - Modern systems don't need this

    # Enable kernel page-table isolation (Meltdown/Spectre mitigation)
    "pti=on" # default: auto - Force enable PTI for security

    # Prevent kernel from merging slabs with similar sizes
    "slab_nomerge" # default: merge enabled - Prevents some heap exploitation techniques

    # Randomize page allocator freelists (makes heap exploits harder)
    "page_alloc.shuffle=1" # default: 0 (disabled) - Enable for exploit mitigation
  ];

  # AppArmor - Mandatory Access Control (MAC)
  # Confines programs to a limited set of resources (files, capabilities, network)
  # Complements traditional Unix discretionary access control (DAC)
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true; # Kill processes that should be confined but aren't
  };

  # Disable Core Dumps
  # Core dumps can contain sensitive data (passwords, encryption keys)
  # Disable them to prevent information leakage
  systemd.coredump.enable = false;
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "core";
      value = "0";
    }
  ];

  # Automatic Security Updates
  # Automatically update to latest NixOS channel to get security patches
  # Does NOT auto-reboot by default (you must manually reboot for kernel updates)
  system.autoUpgrade = {
    enable = lib.mkDefault true;
    allowReboot = lib.mkDefault false; # Set to true in host config if you want auto-reboot
    dates = "daily";
    randomizedDelaySec = "45min"; # Random delay to prevent thundering herd
  };
}
