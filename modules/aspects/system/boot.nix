{ ... }:
{
  den.aspects.boot.nixos = { pkgs, ... }: {
    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.blacklistedKernelModules = [
      "dccp"
      "rds"
      "tipc"
    ];
  };
}
