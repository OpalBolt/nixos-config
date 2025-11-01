{ pkgs, ... }:

{
  # Common CLI Tools Configuration
  # Essential command-line utilities for modern shell workflow

  ## Search & Find Tools

  # Fast line-oriented search tool (better grep replacement)
  # Recursively searches directories for regex patterns
  programs.ripgrep = {
    enable = true;
  };

  # Extension of ripgrep that can search in PDFs, E-Books, Office docs, etc.
  # Automatically detects file types and uses appropriate tools to extract text
  programs.ripgrep-all = {
    enable = true;
  };

  # Simple, fast, user-friendly alternative to 'find'
  # Intuitive syntax, colored output, and respects .gitignore by default
  programs.fd = {
    enable = true;
  };

  # Command-line fuzzy finder
  # Interactive filtering for files, command history, processes, etc.
  programs.fzf = {
    enable = true;
  };

  ## File Viewing & Navigation

  # Modern replacement for 'ls' with better defaults and git integration
  programs.eza = {
    enable = true;
    colors = "always"; # Always use colored output
    icons = "always"; # Display file type icons
    git = true; # Show git status in listings
  };

  # Syntax-highlighted 'cat' clone with git integration and paging
  programs.bat = {
    enable = true;
    config = {
      style = "changes,header"; # Show git modifications and file header (no grid)
      theme = "kanagawa"; # Use custom kanagawa theme for consistent colorscheme
    };

    # Custom theme matching the kanagawa colorscheme
    themes = {
      "kanagawa" = {
        src = pkgs.fetchFromGitHub {
          owner = "rebelot";
          repo = "kanagawa.nvim";
          rev = "debe91547d7fb1eef34ce26a5106f277fbfdd109";
          sha256 = "sha256-i54hTf4AEFTiJb+j5llC5+Xvepj43DiNJSq0vPZCIAg=";
        };
        file = "extras/tmTheme/kanagawa.tmTheme";
      };
    };

    # Additional bat utilities for enhanced functionality
    extraPackages = builtins.attrValues {
      inherit (pkgs.bat-extras)
        #batgrep # Search through and highlight files using ripgrep
        batdiff # Diff files against git index or between two files
        batman # Read manpages using bat as the formatter
        ;
    };
  };

  ## System Monitoring

  # Modern replacement for 'top' and 'htop' with better UI and features
  # Cross-platform graphical process/system monitor with customizable interface
  programs.bottom = {
    enable = true;
  };

  ## Data Processing & Development

  # Lightweight and flexible command-line JSON processor
  # Essential for parsing, filtering, and transforming JSON data
  programs.jq = {
    enable = true;
  };

  # Automatically loads and unloads environment variables per directory
  # nix-direnv provides better integration with Nix than native direnv
  # Essential for project-specific development environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Smart cd command that learns your habits
  # Jump to frequently and recently used directories with fuzzy matching
  programs.zoxide = {
    enable = true;
  };

  ## Nix installed apps
  home.packages = with pkgs; [
    rsync # Fast incremental file transfer utility
    yq-go # Command-line YAML processor
    gdu
  ];
}
