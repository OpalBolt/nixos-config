{ pkgs, vars, ... }:
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

  # try to automatically unlock keyring when logging in as user
  security.pam.services.${vars.username}.enableGnomeKeyring = true;
  security.polkit.enable = true;

  networking.timeServers = [ "dk.pool.ntp.org" ];

}
