{ self, den, inputs, ... }:
{
  # Host aspect for rosi (Framework AMD AI 300, work laptop).
  # Declares which feature aspects to include and adds rosi-specific NixOS config.
  den.aspects.rosi = {
    includes = [
      den.aspects.boot
      den.aspects.nix-settings
      den.aspects.security
      den.aspects.localization
      den.aspects.networking
      den.aspects.ssh
      den.aspects.sops-base
      den.aspects.audio
      den.aspects.bluetooth
      den.aspects.chromium-policies
      den.aspects.containers
      den.aspects.fonts
      den.aspects.hardening
      den.aspects.laptop
      den.aspects.libvirt
      den.aspects.printing
      den.aspects.qmk
      den.aspects.river-wm
      den.aspects.solaar
      den.aspects.thunar
      den.aspects.vpn
      den.aspects.work-vpn
      den.aspects.work-wifi
      den.aspects.mads
      # Framework AMD AI 300 hardware module (injected at flake-parts level)
      { nixos = inputs.hardware.nixosModules.framework-amd-ai-300-series; }
    ];

    nixos =
      { config, lib, pkgs, ... }:
      {
        imports = [
          (self + "/hardware/rosi.nix")
        ];

        # ClamAV antivirus
        services.clamav = {
          daemon.enable = true;
          updater.enable = true;
          updater.interval = "hourly";
        };

        # Desktop: disable fail2ban (hardening.nix enables it by default for servers)
        services.fail2ban.enable = lib.mkForce false;

        # Mutable users disabled — passwords managed via sops
        users.mutableUsers = false;
        users.users.root.shell = pkgs.bash;

        # Per-host sops secrets: host SSH keys and user password hashes
        sops.secrets.ssh-com-pri = {
          sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/rosi.yaml";
          path = "/etc/ssh/ssh_host_ed25519";
          key = "ssh-computer/privateKey";
        };
        sops.secrets.ssh-com-pub = {
          sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/rosi.yaml";
          path = "/etc/ssh/ssh_host_ed25519.pub";
          key = "ssh-computer/publicKey";
        };
        sops.secrets.hashedPassword = {
          sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/rosi.yaml";
          key = "user/password";
          neededForUsers = true;
        };
        sops.secrets.rootHashedPassword = {
          sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/rosi.yaml";
          key = "user/rootPassword";
          neededForUsers = true;
        };
        users.users.mads.hashedPasswordFile = config.sops.secrets.hashedPassword.path;
        users.users.root.hashedPasswordFile = config.sops.secrets.rootHashedPassword.path;

        # hostSpec compatibility shim — not needed in den, but avoids evaluation errors
        # if any legacy module still references it during transition
        # (Remove once all modules are confirmed clean)
      };
  };
}
