{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.time-helper.packages.${pkgs.system}.default
  ];
}
