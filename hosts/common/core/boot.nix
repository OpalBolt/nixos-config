{ pkgs, vars, ... }:
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
}
