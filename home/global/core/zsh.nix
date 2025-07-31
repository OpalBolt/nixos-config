{ config, lib, ... }:

{
  # home.file.".zshenv".text = ''
  #   export ZDOTDIR="$HOME/.config/zsh"
  # '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #dotDir = ".config/zsh";
    enableCompletion = true;
    history = {
      ignoreSpace = true;
      ignoreDups = true;
      size = 1000000;
    };

    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        # Display red dots whilst waiting for completion.
        COMPLETION_WAITING_DOTS="true"
      '';
      plugins = [
        "colored-man-pages"
        "gitignore"
        #"command-not-found"
        "fzf"
        "ssh-agent"
        "git"
        "git-extras"
        "aws"
        "docker"
        "docker-compose"
        "kubectl"
        "opentofu"
        "kind"
        "kitty"
        "sudo"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "djui/alias-tips";
          tags = [
            "from:github"
            "as:plugin"
          ];
        }
        {
          name = "zsh-users/zsh-autosuggestions";
          tags = [
            "from:github"
            "as:plugin"
          ];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [
            "from:github"
            "as:plugin"
            "defer:2"
          ];
        }
        {
          name = "svenXY/timewarrior";
          tags = [
            "from:github"
            "as:plugin"
          ];
        }
      ];
    };

    shellAliases = {

      # =
      # ========== File & Directory Operations ==========
      # =
      ls = "eza -mh1la --classify=always --icons=always --color=always --group-directories-first --git";
      cd = "z"; # use zoxide over cd

      # =
      # ========== Text & File Utilities (Bat) ==========
      # =
      cat = "bat --paging=never";
      diff = "batdiff";
      #rg = "batgrep";
      man = "batman";

      # =
      # ========== Editors ==========
      # =
      vim = "nvim"; # Don't use vim by mistake
      vi = "nvim";

      # =
      # ========== Version Control ==========
      # =
      g = "git";
      lg = "lazygit";
      gle = "podman run --rm -v $\{\PWD}\:/path docker.io/zricethezav/gitleaks:latest git --verbose /path"; # Run git-leaks on current directory

      # =
      # ========== System & Desktop (Ceris) ==========
      # =
      wb = "systemctl --user restart waybar.service";
      wlh = "bash ~/scripts/wlr/home.sh"; # Set screens for home
      wlw = "bash ~/scripts/wlr/work.sh"; # Set screens for work
      neofetch = "fastfetch";

      # =
      # ========== Network & Infrastructure ==========
      # =
      ipa = "ip -br -c a && echo --- && ip -br -c l"; # Better way of getting IP information
      k = "kubectl"; # Kubernetes related

      # =
      # ========== Customer/Business Scripts ==========
      # =
      cu = "bash ~/scripts/customers.sh"; # runs the customer.sh script
      cup = "bash ~/scripts/uploadcustdocument.sh"; # uploads files to gdrive and add it to git

      # =
      # ========== Work Related ==========
      # =
      ovpnw = "sudo openvpn --config /run/secrets/openvpn-efi";

    };
  };
}
