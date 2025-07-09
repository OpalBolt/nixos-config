{ pkgs, lib, ... }:
{
 home.packages = lib.flatten [
    (builtins.attrValues {
      inherit (pkgs)
    slack
    timewarrior
    devenv
    devbox
    awscli2
    ;
    })
  ];
}
