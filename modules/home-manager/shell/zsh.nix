{ config, lib, ... }:

{
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.eza.enable = true;
  programs.eza.enableZshIntegration = true;

  home.file.".zshenv".text = ''
    export ZDOTDIR="$HOME/.config/zsh"
  '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    history = {
      ignoreSpace = true;
      ignoreDups = true;
      size = 1000000;
    };
    oh-my-zsh = {
      enable = true;
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

      wb = "systemctl --user restart waybar.service && nextcloud --background & disown nextcloud";

      # Set screens
      wlh = "bash ~/scripts/wlr/home.sh";
      wlw = "bash ~/scripts/wlr/work.sh";

      # Ensure -al is always used
      ls = "eza -mh1la --classify=always --icons=always --color=always --group-directories-first --git";

      # Dont use vim by mistake
      vim = "nvim";
      vi = "nvim";

      # use g instead of git
      g = "git";
      lg = "lazygit";

      # use zoxide over cd
      cd = "z";

      # add a newline before neofetch
      neofetch = "fastfetch";

      # runs the customer.sh script.
      cu = "bash ~/scripts/customers.sh";

      # uploads files to gdrive and add it to git
      cup = "bash ~/scripts/uploadcustdocument.sh";

      # Run git-leaks on current directory
      gle = "podman run --rm -v $\{\PWD}\:/path docker.io/zricethezav/gitleaks:latest git --verbose /path";

      # Better way of getting IP information
      ipa = "ip -br -c a && echo --- && ip -br -c l";

      # Kubernetes related
      k = "kubectl";

      # =
      # ========== Work related ==========
      # =

      ovpnw = "sudo openvpn --config /run/secrets/openvpn-work";

    };
  };
}
