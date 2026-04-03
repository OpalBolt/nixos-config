{ den, inputs, ... }:
{
  den.aspects.mads = {
    includes = [
      den._.define-user
      (den._.user-shell "zsh")
      den._.primary-user
      # User software aspects — all HM config lives in each aspect
      den.aspects.zsh
      den.aspects.kitty
      den.aspects.shell-tools
      den.aspects.neovim
      den.aspects.firefox
      den.aspects.git
      den.aspects.devops
      den.aspects.xdg
      den.aspects.work
    ];

    # Extra NixOS-level config contributed by mads to every host they're on.
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

    # OS user account attributes
    user = { ... }: {
      uid = 1000;
      description = "Mads Kristiansen";
      homeMode = "0750";
      createHome = true;
      extraGroups = [ "audio" "input" "video" "docker" "optical" "storage" ];
    };

    # Personal HM config — only things that don't belong in a reusable aspect
    homeManager = { pkgs, inputs, config, ... }:
      let
        secretspath = toString inputs.nix-secrets.outPath;
      in
      {
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
          packages = with pkgs; [
            # Communications
            discord
            gurk-rs
            weechat
            # Productivity
            libreoffice
            thunderbird
            obsidian
            # Tools
            bitwarden-desktop
            bitwarden-cli
            unstable.rofi-rbw
            pinentry-tty
            wtype
            rofi
            qsv
            csvlens
            kdePackages.okular
            (writeShellScriptBin "gotask" ''
              exec ${pkgs."go-task"}/bin/task "$@"
            '')
          ];
        };

        # Password manager
        programs.rbw.enable = true;

        # Task management
        programs.taskwarrior = {
          enable = true;
          package = pkgs.taskwarrior3;
        };

        # Cloud sync
        services.nextcloud-client = {
          enable = true;
          startInBackground = true;
        };

        # Blue-light filter
        services.gammastep = {
          enable = true;
          provider = "manual";
          latitude = 56.04;
          longitude = 12.6;
          tray = true;
        };

        # Fabric AI assistant
        sops.secrets."zai/fabrictoken".sopsFile = "${secretspath}/secrets/per-mads.yaml";
        programs.fabric-ai.enable = true;
        programs.zsh.initContent = ''
          if [ -f "${config.sops.secrets."zai/fabrictoken".path}" ]; then
            export OPENAI_API_KEY=$(cat ${config.sops.secrets."zai/fabrictoken".path})
            export OPENAI_API_BASE_URL="https://api.z.ai/v1"
          fi

          noglob_qq() {
            fabric --pattern=linux_commands --stream --thinking=low "$*"
          }
          alias '??'='noglob noglob_qq'
        '';
      };
  };
}
