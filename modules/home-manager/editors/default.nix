{ pkgs, lib, vars, ... }:

{
  imports = [
    ./neovim
    ./nixvim
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  #neovim.enable = true;
  #nixvim.enable = true;
}
