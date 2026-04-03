{ config, lib, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    history = {
      ignoreSpace = true;
      ignoreDups = true;
      size = 1000000;
    };
    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        COMPLETION_WAITING_DOTS="true"
      '';
      plugins = [
        "colored-man-pages"
        "gitignore"
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
      ls = "eza -mh1la --classify=always --icons=always --color=always --group-directories-first --git";
      cd = "z";
      cat = "bat --paging=never";
      diff = "batdiff";
      man = "batman";
      vim = "nvim";
      vi = "nvim";
      g = "git";
      lg = "lazygit";
      gle = "podman run --rm -v $\{PWD}:/path docker.io/zricethezav/gitleaks:latest git --verbose /path";
      wb = "systemctl --user restart waybar.service";
      wlh = "bash ~/scripts/wlr/home.sh";
      wlw = "bash ~/scripts/wlr/work.sh";
      neofetch = "fastfetch";
      ipa = "ip -br -c a && echo --- && ip -br -c l";
      k = "kubectl";
      cu = "bash ~/scripts/customers.sh";
      cup = "bash ~/scripts/uploadcustdocument.sh";
      ovpnw = "sudo openvpn --config /run/secrets/openvpn-efi";
    };
  };
}
