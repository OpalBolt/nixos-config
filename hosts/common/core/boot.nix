{ pkgs, vars, lib, config, ... }:
let
  # this will print “⎯⎯ boot.nix is being evaluated ⎯⎯” during evaluation
  _ = builtins.trace "⎯⎯ boot.nix is being evaluated ⎯⎯" null;
in
{
  # Bootloader.
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # use latest kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Harden network stack by disabling unused protocols
  boot.blacklistedKernelModules = [
    # Always disable these rare/unused protocols
    "dccp"
    "rds"
    "tipc"
  ] ++ lib.optionals config.hostSpec.isMinimal [
    # Only disable SCTP on minimal systems (servers/endpoints)
    # Kept enabled on workstations for Kubernetes/Containers compatibility
    "sctp"
  ];
}
