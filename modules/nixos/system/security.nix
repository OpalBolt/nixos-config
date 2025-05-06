{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{

  # only allow users that has sudo permissions to interact with nix pkgs
  nix.settings.allowed-users = [ "@wheel" ];
  security.sudo.execWheelOnly = true;
  environment.defaultPackages = lib.mkForce [ ];
  systemd.coredump.enable = false;
  security.chromiumSuidSandbox.enable = true;
  #environment.memoryAllocator.provider = "libc";

  # Install requried software
  environment.systemPackages = [
    pkgs.clamav
  ];

  # Enable ClamAV
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  services.openssh = {
    settings = {
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
    };
    allowSFTP = false; # Don't set this if you need sftp
  };

  security.loginDefs.settings = {
    PASS_MIN_DAYS = 1;
    YESCRYPT_COST_FACTOR = 8;
  };

}
