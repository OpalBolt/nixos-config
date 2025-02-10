{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.feature.common-pkgs.enable = lib.mkEnableOption "Enables common packages" // {
    default = true;
  };

  config = lib.mkIf config.feature.common-pkgs.enable {

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Remove packages that are not needed
    environment.defaultPackages = lib.mkForce [ ];
    environment.systemPackages = with pkgs; [

      # Archive managers
      zip
      unzip
      xz

      # Netowrking tools
      wget
      curl

      # Editors
      vim

      # Misc
      kitty # Terminal
      git # Source versioning
      file # determine file type
      tree # List how a folder is structured
      ripgrep # Better grep
      jq # Json Query
      yq # Yaml Query
      bottom # Top like tool
      gcc # C Compiler
      fzf # Fuzzy search
      go-task # Task runner
      nix-tree # Browse packages
      xdg-utils # Tools for desktop integrations
      xdg-launch # Cli for launching desktop tools
      ungoogled-chromium # TODO Remove tfetchGit
      zoxide # CD alternative
      eza # LS Alternative
      bat # cat alternative
      util-linux # system utilities for Linux

      # Nix related
      nixfmt-rfc-style # Nix formatter

      # System tools
      pciutils
      usbutils

      # Wayland tools
      #nwg-look
      #nwg-displays
      wl-clipboard

      # Communication tools
      Thunderbird
      weechat

    ];

  };
}
