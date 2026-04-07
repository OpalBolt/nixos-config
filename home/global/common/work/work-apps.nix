{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = lib.flatten [
    inputs.secure-handling-of-secrets.packages.${pkgs.system}.envoke
    (builtins.attrValues {
      inherit (pkgs)
        slack
        timewarrior
        awscli2

        ;
    })
  ];
  programs.zsh.initContent = ''
    eval "$(envoke shell-init)"
  '';
}
