{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.time-helper.packages.${pkgs.system}.default
  ];

  home.shellAliases = {
    th = "time-helper";
  };
}
