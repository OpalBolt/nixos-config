{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Core editors and utilities
    vim # Vi improved text editor
    ripgrep # Fast grep alternative with better regex support
    fd # Fast find alternative with intuitive syntax
    tree-sitter # Parser generator for syntax highlighting

    # Python tools and language servers
    python3 # Python 3 interpreter
    black # Python code formatter
    basedpyright # Fast Python type checker (Pyright fork)
    pyright # Microsoft's Python language server
    ruff # Fast Python linter and formatter
    python312Packages.debugpy # Python debugger adapter protocol implementation

    # Go development tools
    go # Go programming language compiler
    gopls # Go language server protocol implementation
    gofumpt # Stricter gofmt formatter for Go

    # Rust development tools
    cargo # Rust package manager and build tool
    rustc # Rust compiler

    # Lua tools
    lua-language-server # Lua language server for LSP support
    stylua # Lua code formatter

    # Nix tools
    nil # Nix language server
    nixfmt-rfc-style # Nix code formatter following RFC style

    # Web development language servers
    nodePackages_latest.vscode-json-languageserver # JSON language server for validation and completion

    # Docker tools
    docker-compose-language-service # Docker Compose YAML language server
    docker-ls # Dockerfile language server

    # Markdown tools
    markdownlint-cli2 # Markdown linter for style checking
    marksman # Markdown language server

    # Other language servers and tools
    starlark-rust # Starlark (Bazel) language tools

    # Neovim plugins
    vimPlugins.markdown-preview-nvim # Live markdown preview in browser
    #vimPlugins.nvim-dap                                  # Debug Adapter Protocol client for Neovim
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
      source = config.lib.file.mkOutOfStoreSymlink (lib.custom.relativeToRoot "dotfiles/nvim");
      recursive = true;
    };
  };
}
