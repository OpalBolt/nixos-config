{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.neovim-config-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
