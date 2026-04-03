{ self, inputs, ... }:
{
  den.aspects.neovim.homeManager = { inputs, pkgs, ... }: {
    imports = [ inputs.lazyvim.homeManagerModules.default ];
    programs.lazyvim = {
      enable = true;
      configFiles = self + "/dotfiles/lazyvim";
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
        };
      };
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
  };
}
