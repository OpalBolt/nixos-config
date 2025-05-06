{ ... }:

{
  imports = [
    #./nixvim.nix
    ./neovim.nix
    #./nixcats
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
