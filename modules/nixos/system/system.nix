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
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      // NM “actions” for modifying or activating system or own connections
      const allow = [
        "org.freedesktop.NetworkManager.settings.modify.system",
        "org.freedesktop.NetworkManager.settings.modify.own",
        "org.freedesktop.NetworkManager.settings.activate.system",
        "org.freedesktop.NetworkManager.settings.activate.own"
      ];
      // if user is in wheel, always allow those actions
      if (subject.isInGroup("wheel") && allow.indexOf(action.id) !== -1) {
        return polkit.Result.YES;
      }
    });
  '';

  networking.timeServers = [ "dk.pool.ntp.org" ];

}
