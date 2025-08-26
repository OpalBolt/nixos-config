{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.nixCats-test.packages.${pkgs.system}.default
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
