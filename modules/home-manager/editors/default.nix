{ ... }:

{
  imports = [
    #./nixvim.nix
    ./neovim.nix
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
