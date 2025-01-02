# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, vars, ... }:

{

  imports = [
    ./../modules/nixos/system/networking
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = vars.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = vars.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.extraLocale;
    LC_IDENTIFICATION = vars.extraLocale;
    LC_MEASUREMENT = vars.extraLocale;
    LC_MONETARY = vars.extraLocale;
    LC_NAME = vars.extraLocale;
    LC_NUMERIC = vars.extraLocale;
    LC_PAPER = vars.extraLocale;
    LC_TELEPHONE = vars.extraLocale;
    LC_TIME = vars.extraLocale;
  };

  # Configure console keymap
  console.keyMap = vars.consoleKbdKeymap;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Iosevka NFM:style=Regular" ];
      };
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

#  home-manager = {
#	extraSpecialArgs = { inherit inputs; };
#	users = {
#		mads = import ./home.nix;
#	};
#  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  kitty
  git
  tree
  util-linux
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/mads/nixos-config";
  };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
