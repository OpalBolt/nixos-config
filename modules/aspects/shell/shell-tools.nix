{ ... }:
{
  den.aspects.shell-tools.homeManager = { pkgs, ... }: {
    programs.ripgrep.enable = true;
    programs.ripgrep-all.enable = true;
    programs.fd.enable = true;
    programs.fzf.enable = true;
    programs.eza = {
      enable = true;
      colors = "always";
      icons = "always";
      git = true;
    };
    programs.bat = {
      enable = true;
      config = {
        style = "changes,header";
        theme = "kanagawa";
      };
      themes."kanagawa" = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "debe91547d7fb1eef34ce26a5106f277fbfdd109";
          sha256 = "sha256-i54hTf4AEFTiJb+j5llC5+Xvepj43DiNJSq0vPZCIAg=";
        };
        file = "extras/tmTheme/kanagawa.tmTheme";
      };
      extraPackages = with pkgs.bat-extras; [ batdiff batman ];
    };
    programs.bottom.enable = true;
    programs.jq.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        use_renv() {
          local file="''${1:-.env}"
          watch_file "$file"
          eval "$(renv unload 2>/dev/null || true)"
          eval "$(renv resolve "$file")"
        }
      '';
    };
    programs.zoxide.enable = true;
    programs.yazi.enable = true;
    programs.yazi.enableZshIntegration = true;
    programs.yazi.enableBashIntegration = true;
    programs.yazi.enableFishIntegration = true;
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings.theme = "kanagawa";
    };
    xdg.configFile."zellij/config.kdl".source = ../../../dotfiles/zellij/config.kdl;
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        format = "$all";
        right_format = "\${custom.timewarrior}";
        custom.timewarrior = {
          command = "~/scripts/timew_status.sh";
          when = "true";
          shell = [ "bash" "--noprofile" "--norc" ];
          format = " [$output]($style)";
          style = "bold green";
        };
      };
    };
    programs.tealdeer.enable = true;
    programs.tealdeer.settings.updates.auto_update = true;
    home.packages = with pkgs; [ rsync yq-go gdu dogdns ];
  };
}
