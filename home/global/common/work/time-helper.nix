{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.time-helper.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.shellAliases = {
    th = "time-helper";
  };
}
