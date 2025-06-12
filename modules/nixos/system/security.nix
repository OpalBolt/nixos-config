{
  lib,
  pkgs,
  ...
}:

{

  # only allow users that has sudo permissions to interact with nix pkgs
  #nix.settings.allowed-users = [ "@wheel" ];
  #security.sudo.execWheelOnly = true;
  environment.defaultPackages = lib.mkForce [ ];
  systemd.coredump.enable = false;
  #security.chromiumSuidSandbox.enable = true;
  #environment.memoryAllocator.provider = "libc";

  # Install requried software
  environment.systemPackages = [
    pkgs.clamav
    pkgs.age
    pkgs.sops
  ];

  # Enable ClamAV
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "hourly";
  };
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  services.openssh = {
    enable = true;
    #listenAddresses = [ { addr = "127.0.0.1:65535"; } ]; # Prevent SSHD from binding
    listenAddresses = [ ]; # Prevent SSHD from binding
    settings = {
      PasswordAuthentication = false;
      challengeResponseAuthentication = false;
      PermitRootLogin = "no";
    };
    hostKeys = [
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
        rounds = 100;
      }
    ];
    allowSFTP = false; # Don't set this if you need sftp
  };

  security.loginDefs.settings = {
    PASS_MIN_DAYS = 1;
    YESCRYPT_COST_FACTOR = 8;
  };

}
