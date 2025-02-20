{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    feature.cli.neovim.enable = lib.mkEnableOption "Enables neovim" // {
      default = true;
    };
  };
  config = lib.mkIf config.feature.cli.neovim.enable {
    #    home.file = {
    #    	".config/nvim" = {
    # 	source = lib.file.mkOutOfStireSymlink ./configfiles/neovim-config;
    # 	recursive = true;
    # 	};
    # };
    #xdg.configFile.".config/nvim".source = ./configfiles/neovim-config;
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
      extraPackages = [
        pkgs.nodePackages_latest.vscode-json-languageserver
        pkgs.lua-language-server
        pkgs.nil
        pkgs.go
        pkgs.gopls
        pkgs.gofumpt
        pkgs.stylua
        pkgs.cargo
        pkgs.rustc
        pkgs.python3
        pkgs.basedpyright
        pkgs.ruff
        pkgs.nixfmt-rfc-style
        pkgs.starlark-rust
        pkgs.docker-compose-language-service
        pkgs.docker-ls
        pkgs.markdownlint-cli2
        pkgs.marksman
        pkgs.tree-sitter
      ];
    };
  };
}
