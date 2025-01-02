{config, lib, ... }:

{
  options = {
    zsh.enable = 
      lib.mkEnableOption "Enables zsh shell";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      histSize = 100000;
      history = {
        ignoreSpace = true;
        ignoreDubs = true;
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
