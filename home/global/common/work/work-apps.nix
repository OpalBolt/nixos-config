{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = lib.flatten [

    inputs.secure-handling-of-secrets.packages.${pkgs.system}.renv
    inputs.secure-handling-of-secrets.packages.${pkgs.system}.kctx
    (builtins.attrValues {
      inherit (pkgs)
        slack
        timewarrior
        awscli2

        ;
    })
  ];
}
