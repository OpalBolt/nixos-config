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
    environment.systemPackages = with pkgs; [
      # Archive managers
      zip
      unzip
      xz

      # Netowrking tools
      wget
      curl

      # Misc
      file
      tree
      wl-clipboard
      vim
      ripgrep
      jq
      yq
      bottom
      gcc
      fzf
      go-task
      nix-tree # Browse packages

      # System tools
      pciutils
      usbutils

      # Wayland tools
      nwg-look
      nwg-displays

    ];
  };
}
