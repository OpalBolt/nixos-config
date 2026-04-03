{ inputs, ... }:
{
  programs.lazygit.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user.name = inputs.nix-secrets.handle;
      user.email = inputs.nix-secrets.email.git;
    };
    ignores = [
      "result"
      "result-*"
      "*.drv"
      ".direnv"
      ".envrc"
      ".csvignore"
    ];
    attributes = [
      "*.sh    text eol=lf"
      "*.nix   text eol=lf"
      ".envrc  text eol=lf"
    ];
  };
}
