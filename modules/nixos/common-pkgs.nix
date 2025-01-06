{lib, config, pkgs, ...}:

{
  options.nos.common-pkgs.enable = 
    lib.mkEnableOption "Enables common packages" // {default = true;};

  config = lib.mkIf config.nos.common-pkgs.enable {
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

      # System tools
      pciutils
      usbutils

    ];
  };
}
