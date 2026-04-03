{ den, inputs, ... }:
{
  den.aspects.mads = {
    includes = [
      den._.define-user
      (den._.user-shell "zsh")
      den._.primary-user
    ];

    # Extra NixOS-level config contributed by the mads user to every host they're on.
    # Use provides.to-hosts for user → host NixOS contributions (requires mutual-provider).
    provides.to-hosts.nixos = { ... }: {
      security.pam.services.mads.enableGnomeKeyring = true;
      sops.age.keyFile = "/home/mads/.config/sops/age/keys.txt";
      sops.secrets.ssh-per-pri = {
        sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/per-mads.yaml";
        owner = "mads";
        path = "/home/mads/.ssh/id_ed25519";
        key = "ssh/privateKey";
      };
      sops.secrets.ssh-per-pub = {
        sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/per-mads.yaml";
        owner = "mads";
        path = "/home/mads/.ssh/id_ed25519.pub";
        key = "ssh/publicKey";
      };
    };

    # Extra user account attributes (forwarded to users.users.mads by den._.os-user).
    user = { ... }: {
      uid = 1000;
      description = "Mads Kristiansen";
      homeMode = "0750";
      createHome = true;
      extraGroups = [
        "audio"
        "input"
        "video"
        "docker"
        "optical"
        "storage"
      ];
    };

    # Home Manager configuration for mads.
    homeManager =
      { pkgs, inputs, config, ... }:
      {
        imports = [
          ../../home/core/sops.nix
          ../../home/core/git.nix
          ../../home/core/locals.nix
          ../../home/core/zsh.nix
          ../../home/core/fonts.nix
          ../../home/desktop/river.nix
          ../../home/desktop/gtk.nix
          ../../home/browsers/firefox.nix
          ../../home/shell/kitty.nix
          ../../home/shell/starship.nix
          ../../home/shell/tealdeer.nix
          ../../home/shell/yazi.nix
          ../../home/shell/zellij.nix
          ../../home/shell/common-tools.nix
          ../../home/shell/web-tools.nix
          ../../home/editors/neovim.nix
          ../../home/editors/obsidian.nix
          ../../home/dev/git.nix
          ../../home/dev/devops.nix
          ../../home/work/work-apps.nix
          ../../home/work/time-helper.nix
          ../../home/work/work-audit.nix
          ../../home/work/backup-customers.nix
          ../../home/comms/discord.nix
          ../../home/comms/weechat.nix
          ../../home/productivity/libreoffice.nix
          ../../home/productivity/nextcloud.nix
          ../../home/productivity/thunderbird.nix
          ../../home/productivity/taskmanager.nix
          ../../home/tools/bitwarden.nix
          ../../home/tools/csv.nix
          ../../home/tools/go-task.nix
          ../../home/tools/nix-related.nix
          ../../home/sys/xdg.nix
          ../../home/sys/complex-fonts.nix
          ../../home/ai/fabric.nix
          ../../home/common.nix
        ];

        home = {
          stateVersion = "24.05";
          sessionVariables = {
            CUSTOMERS_PATH = "/home/mads/git/work/customers/";
            EDITOR = "nvim";
            VISUAL = "nvim";
            FLAKE = "/home/mads/git/Nix/nixos-config";
            SHELL = "${pkgs.zsh}/bin/zsh";
            TERM = "kitty";
            TERMINAL = "kitty";
          };
          file."scripts" = {
            source = ../../dotfiles/scripts;
            recursive = true;
          };
          preferXdgDirectories = true;
        };
      };
  };
}
