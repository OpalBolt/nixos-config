{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    feature.security = {
      enable = lib.mkEnableOption "General security" // {
        default = true;
      };
      av.enable = lib.mkEnableOption "Enables ClamAV" // {
        default = true;
      };
      audit.enable = lib.mkEnableOption "Enables audit" // {
        default = true;
      };
      sshd-disable = lib.mkEnableOption "Disables SSHD features" // {
        default = true;
      };

    };
  };

  config = lib.mkIf config.feature.security.enable (
    lib.mkMerge [

      # only allow users that has sudo permissions to interact with nix pkgs
      {
        nix.settings.allowed-users = [ "@wheel" ];
        security.sudo.execWheelOnly = true;
        environment.defaultPackages = lib.mkForce [ ];
        systemd.coredump.enable = false;
        security.chromiumSuidSandbox.enable = true;

      }

      (lib.mkIf config.feature.security.av.enable {
        # Install requried software
        environment.systemPackages = [
          pkgs.clamav
        ];

        # Enable ClamAV
        services.clamav.daemon.enable = config.feature.security.av.enable;
        services.clamav.updater.enable = config.feature.security.av.enable;
      })
      (lib.mkIf config.feature.security.audit.enable {
        security.auditd.enable = true;
        security.audit.enable = true;
        security.audit.rules = [
          "-a exit,always -F arch=b64 -S execve"
        ];

      })
      (lib.mkIf config.feature.security.sshd-disable {
        services.openssh = {
          settings = {
            passwordAuthentication = false;
            challengeResponseAuthentication = false;
          };
          allowSFTP = false; # Don't set this if you need sftp
          extraConfig = ''
            AllowTcpForwarding yes
            X11Forwarding no
            AllowAgentForwarding no
            AllowStreamLocalForwarding no
            AuthenticationMethods publickey
          '';
        };

      })
    ]
  );
}
