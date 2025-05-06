{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    black
    nodePackages_latest.vscode-json-languageserver
    lua-language-server
    nil
    go
    gopls
    gofumpt
    stylua
    cargo
    rustc
    python3
    basedpyright
    pyright
    ruff
    nixfmt-rfc-style
    starlark-rust
    docker-compose-language-service
    docker-ls
    markdownlint-cli2
    marksman
    tree-sitter
    vimPlugins.markdown-preview-nvim
    #vimPlugins.nvim-dap
    python312Packages.debugpy
  ];

  programs.neovim = {
    enable = true;
    #package = pkgs-unstable.neovim-unwrapped;
    #package = pkgs.neovim;
    vimAlias = true;
    withNodeJs = true;

    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };
  home.file = {
    ".config/nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/mads/nix-dots/dotfiles/nvim";
      recursive = true;
    };
  };
}
