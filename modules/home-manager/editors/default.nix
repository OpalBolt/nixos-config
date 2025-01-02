{ pkgs, lib, vars, ... }:

{
  imports = [
    ./neovim
    ./nixvim
  ];
   home.sessionVariables = {
     EDITOR = "nvim";
   };
  neovim.enable = false;
  nixvim.enable = true;
}
