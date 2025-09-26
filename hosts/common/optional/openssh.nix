{
  lib,
  config,
  hostSpec,
  ...
}:
let
  sshPort = config.hostSpec.networking.ports.tcp.ssh;
in

{
  services.openssh = {
    enable = false;
    ports = [ sshPort ];

    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "$/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # yubikey login / sudo
  security.pam = {
    rssh.enable = true;
    services.sudo.rssh = true;
  };
}
