{
  inputs,
  ...
}:

{
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  programs.lazyvim.enable = true;
}
