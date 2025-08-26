{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.nixCats-test.packages.${pkgs.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
  };
}
