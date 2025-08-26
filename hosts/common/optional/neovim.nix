{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.neovim-config-nix.packages.${pkgs.system}.default
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
