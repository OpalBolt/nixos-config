# Hardware configuration for Pangolin reverse proxy server
# This is a minimal server configuration - adjust based on actual hardware

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Filesystem configuration
  # Adjust this based on your actual disk layout
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Disable microcode updates if not needed
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # CPU - adjust based on actual hardware
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
