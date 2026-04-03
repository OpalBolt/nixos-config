{ pkgs, ... }:
{
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
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];
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
  home.packages = with pkgs; [
    rsync
    yq-go
    gdu
  ];
}
