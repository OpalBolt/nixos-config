{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # use latest kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable experimental-features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enabling polkit
  security.polkit.enable = true;

}
