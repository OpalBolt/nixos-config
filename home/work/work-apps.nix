{ pkgs, lib, inputs, ... }:
{
  home.packages = lib.flatten [
    inputs.secure-handling-of-secrets.packages.${pkgs.system}.renv
    inputs.secure-handling-of-secrets.packages.${pkgs.system}.kctx
    (with pkgs; [
      slack
      timewarrior
      awscli2
    ])
  ];
  programs.zsh.initContent = ''
    eval "$(renv shell-init)"
    eval "$(kctx shell-init)"
  '';
}
