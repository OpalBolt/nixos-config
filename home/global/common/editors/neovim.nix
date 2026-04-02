{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    # Use file-based config from dotfiles
    configFiles = lib.custom.relativeToRoot "dotfiles/lazyvim";

    # Language extras (replaces init.lua imports from old nixCats config)
    extras = {
      lang = {
        markdown.enable = true;
        nix.enable = true;
        docker.enable = true;
        python = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        yaml.enable = true;
        json.enable = true;
        toml.enable = true;
        ansible.enable = true;
        # terraform.enable = true;
        # go.enable = true;
      };
    };

    # Extra packages not covered by extras (replaces lspsAndRuntimeDeps from nixCats)
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      marksman
      markdownlint-cli2
      hadolint
      yaml-language-server
      vscode-langservers-extracted
      python313Packages.debugpy
    ];
  };
}
