# Hardware configuration for rosi (Framework AMD AI 300 Series)
# DO NOT regenerate with nixos-generate-config — this file is handcrafted.
# Note: inputs.hardware.nixosModules.framework-amd-ai-300-series is imported
# from the rosi aspect (modules/aspects/rosi.nix) to avoid inputs in imports.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1dfb6a12-e0b1-4910-8e61-6cb43d9838f7";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-0d4197b1-42c9-456d-b3e1-60fa421af6bc".device =
    "/dev/disk/by-uuid/0d4197b1-42c9-456d-b3e1-60fa421af6bc";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5712-779B";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
