# https://github.com/sharkdp/bat
# https://github.com/eth-p/bat-extras

{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      # Git modifications and file header (but no grid)
      style = "changes,header";
      theme = "kanagawa";
    };

    themes = {
      "kanagawa" = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim"; # Bat uses sublime syntax for its themes
          rev = "debe91547d7fb1eef34ce26a5106f277fbfdd109";
          sha256 = "sha256-i54hTf4AEFTiJb+j5llC5+Xvepj43DiNJSq0vPZCIAg=";
        };
        file = "extras/tmTheme/kanagawa.tmTheme";
      };
    };

    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras)

        batgrep # search through and highlight files using ripgrep
        batdiff # Diff a file against the current git index, or display the diff between to files
        batman # read manpages using bat as the formatter
        ;
    };
  };
}
