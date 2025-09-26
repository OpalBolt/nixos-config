# Git configuration and development utilities
{
  inputs,
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:

let
  # Email and identity configuration
  publicGitEmail = inputs.nix-secrets.email.git;
  workEmail = inputs.nix-secrets.email.work;

  # SSH and signing configuration
  sshFolder = "${config.home.homeDirectory}/.ssh";
  publicKey = "${sshFolder}/id_ed25519.pub";

  # Git configuration file paths
  privateGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.private";
  workGitConfig = "${config.home.homeDirectory}/.config/git/gitconfig.work";
in

{
  # Development packages
  home.packages = lib.flatten [
    (builtins.attrValues {
      inherit (pkgs)
        direnv
        delta
        act # GitHub workflow runner
        gh # GitHub CLI
        yq-go # YAML/TOML parser that mirrors jq
        ;
    })
  ];

  # Git program configuration
  programs.git = {
    # Basic identity
    userName = hostSpec.handle;
    userEmail = publicGitEmail;

    # Core git settings
    extraConfig = {
      # General settings
      #log.showSignature = "true";
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = true;
      core.editor = "nvim";
      push.autoSetupRemote = true;

      # Directory-specific configurations
      includeIf."gitdir:${config.home.homeDirectory}/git/personal/".path = privateGitConfig;
      includeIf."gitdir:${config.home.homeDirectory}/nix/".path = privateGitConfig;
      includeIf."gitdir:${config.home.homeDirectory}/work/".path = workGitConfig;

      # Diff tool
      diff.tool = "delta";

      # GPG signing configuration
      commit.gpgsign = false;
      #gpg.format = "ssh";
      #user.signingkey = "${publicKey}";
      #gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };

    # Signing configuration
    #signing = {
    #  signByDefault = false;
    #  key = publicKey;
    #};

    # Global gitignore patterns
    ignores = [
      # Nix
      "result"
      "result-*"
      "*.drv"

      # Development tools
      ".direnv"
      ".envrc"
      ".csvignore"

      # Python
      "*.py?"
      "*.pyc"
      "__pycache__/"
      ".venv/"
      "venv/"
      ".env"
      ".pytest_cache/"
      "*.egg-info/"
      "dist/"
      "build/"

      # Editor/IDE
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"

      # OS
      ".DS_Store"
      "Thumbs.db"

      # Logs and temporary files
      "*.log"
      "*.tmp"
      ".cache/"
    ];

    # Delta diff viewer configuration
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        navigate = true;
        light = false;
        line-numbers = true;
        commit-decoration = true;
        #syntax-theme = "Github";
        zero-style = "syntax dim";
        minus-style = "syntax bold auto";
      };
    };

    # Git aliases
    aliases = {
      # Meta
      aliases = "!git config --list | grep 'alias\\.' | sed 's/alias\\.\\([^=]*\\)=\\(.*\\)/\\1\\ \t => \\2/' | sort";

      # Basic operations
      unstage = "reset HEAD --";
      cm = "commit -m";
      s = "status";
      p = "push";
      b = "branch -avv";
      ci = "clean -i";
      init = "commit -m \"Initial commit\"";

      # Log views
      g = "!git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative --all";
      l = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10";
      la = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10 --all";
      lag = "!git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset %s' --abbrev-commit --date=relative -n 10 --all --graph";
    };
  };

  # SSH allowed signers file
  #home.file.".ssh/allowed_signers".text = ''
  #  ${publicGitEmail} ${inputs.nix-secrets.networking.ssh.publicKeys.opalbolt}
  #'';

  # Private git configuration
  home.file."${privateGitConfig}".text = ''
    [user]
      name = "${hostSpec.handle}"
      email = ${publicGitEmail}
  '';

  # Work git configuration
  home.file."${workGitConfig}".text = ''
    [user]
      name = "${hostSpec.userFullName}"
      email = "${workEmail}"
  '';
}
