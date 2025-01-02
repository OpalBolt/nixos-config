{config, lib, ... }:

{
  options = {
    zsh.enable = 
      lib.mkEnableOption "Enables zsh shell";
  };

  config = lib.mkIf config.zsh.enable {
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
        plugins = [
          "colored-man-pages"
          "command-not-found"
          "git" 
          "aws" 
          "docker" 
          "docker-compose"
          "kubectl"
          "opentofu"
          "kind"
          "kitty"
        ];
      };
    };
  };
}
